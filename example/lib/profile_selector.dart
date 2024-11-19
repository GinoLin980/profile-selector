import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class ProfileSelector extends StatefulWidget {
  final int size;
  final String? imageUrl;
  final File? imageFile;
  final IconData icon;
  final String cropperTitle;
  final bool changeable;

  // Default values
  const ProfileSelector({
    Key? key,
    this.size = 40,
    this.imageFile,
    this.icon = Icons.person,
    this.cropperTitle = "Cropper",
    this.changeable = true,
    this.imageUrl,
  }) : super(key: key);

  @override
  ProfileSelectorState createState() => ProfileSelectorState();
}

class ProfileSelectorState extends State<ProfileSelector> {
  late int size;
  File? _selectedImage;
  String? imageUrl;
  late Future<void> _initializationFuture;

  @override
  void initState() {
    super.initState();
    size = widget.size < 40 ? 40 : widget.size; // Minimal size of 40 for image button
    imageUrl = widget.imageUrl; // save in state for easy access on getImage()
    _initializationFuture = _initializeImage();
  }

  Future<void> _initializeImage() async {
    if (imageUrl != null) {
      try {
        _selectedImage = await urlToFile(imageUrl!);
      } catch (e) {
        print("Error loading image from URL: $e");
      }
    } else if (widget.imageFile != null) {
      _selectedImage = widget.imageFile;
    }
  }

  // Save image from url to cache and return its file
  Future<File> urlToFile(String imageUrl) async {
    final dir = await getTemporaryDirectory();
    final filename = '${DateTime.now().millisecondsSinceEpoch}.png';
    final path = '${dir.path}/$filename';

    final response = await http.get(Uri.parse(imageUrl)).timeout(const Duration(seconds: 5)); // timeout is set as 5 seconds
    if (response.statusCode != 200) {
      throw Exception('Failed to download image: ${response.statusCode}');
    }

    final file = File(path);
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<dynamic> getImage() async {
    await _initializationFuture;
    return imageUrl ?? _selectedImage; // url priority is higher than file because they will both eventually become files
  }

    Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: widget.cropperTitle,
            cropStyle: CropStyle.circle, // cropping shape or style
          ),
          IOSUiSettings(
            title: widget.cropperTitle,
            cropStyle: CropStyle.circle // cropping shape or style
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          imageUrl = null; // make imageUrl to null once user has selected a local image
          _selectedImage = File(croppedFile.path);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
            child: const CircularProgressIndicator(),
          );
        }

        return GestureDetector(
          onTap: widget.changeable ? _pickImage : null,
          child: Container(
            width: widget.size.toDouble(),
            height: widget.size.toDouble(),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: _selectedImage != null
                  ? DecorationImage(image: FileImage(_selectedImage!), fit: BoxFit.cover)
                  : null,
              color: Colors.grey[200],
            ),
            child: _selectedImage == null
                ? Icon(widget.icon, size: widget.size * 0.6, color: Colors.grey)
                : null,
          ),
        );
      },
    );
  }
}


