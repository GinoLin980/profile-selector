import 'package:flutter/material.dart';
import 'profile_selector.dart';

void main() {
  runApp(MaterialApp(home: Scaffold(
    appBar: AppBar(title: Text("Profile Selector Demo")),
    body: Column(children: [
      ProfileSelectorDemo(),
      // YourView(),
    ],),
  )
  )
  );
}

class ProfileSelectorDemo extends StatefulWidget {
  const ProfileSelectorDemo({super.key});

  @override
  State<ProfileSelectorDemo> createState() => _ProfileSelectorDemoState();
}

class _ProfileSelectorDemoState extends State<ProfileSelectorDemo> {
  final GlobalKey<ProfileSelectorState> profile1Key = GlobalKey<ProfileSelectorState>();
  final GlobalKey<ProfileSelectorState> unchangeableProfileKey = GlobalKey<ProfileSelectorState>();
  final GlobalKey<ProfileSelectorState> nullProfileKey = GlobalKey<ProfileSelectorState>();
  
  String profile1Image = "";
  String unchangeableProfileImage = "";
  String nullProfileImage = "";

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ProfileSelector(
            key: profile1Key, 
            size: 100, 
            imageUrl: "https://th.bing.com/th/id/OIP.1-I8TZnZm0iLdZgCifBHFgHaFj?w=238&h=180&c=7&r=0&o=5&dpr=1.8&pid=1.7",
          ),
          ElevatedButton(
            onPressed: () async{
              dynamic retrievedImage = await profile1Key.currentState?.getImage();
              retrievedImage = retrievedImage.toString();
              setState(() {
                profile1Image = retrievedImage ?? "";
              });
            }, 
            child: Text("Get data in profile1")
          ),
          Text(profile1Image),
          
          ProfileSelector(
            key: unchangeableProfileKey, 
            size: 100, 
            changeable: false, 
            imageUrl: "https://th.bing.com/th/id/OIP.1-I8TZnZm0iLdZgCifBHFgHaFj?w=238&h=180&c=7&r=0&o=5&dpr=1.8&pid=1.7",
          ),
          ElevatedButton(
            onPressed: () async{
              dynamic retrievedImage = await unchangeableProfileKey.currentState?.getImage();
              retrievedImage = retrievedImage.toString();
              setState(() {
                unchangeableProfileImage = retrievedImage ?? "";
              });
            }, 
            child: Text("Get data in unchangeable profile")
          ),
          Text(unchangeableProfileImage),

           ProfileSelector(
            key: nullProfileKey, 
            size: 100, 
            changeable: false, 
          ),
          ElevatedButton(
            onPressed: () async{
              dynamic retrievedImage = await nullProfileKey.currentState?.getImage();
              retrievedImage = retrievedImage.toString();
              setState(() {
                nullProfileImage = retrievedImage ?? "";
              });
            }, 
            child: Text("Get data in null profile(unchangeable)")
          ),
          Text(nullProfileImage),
        ],
      );
  }
}


class YourView extends StatefulWidget {
  const YourView({super.key});

  @override
  State<YourView> createState() => _YourViewState();
}

class _YourViewState extends State<YourView> {
    // create a key for corresponding profile selector, this is crucial for fetching image/URL
    final GlobalKey<ProfileSelectorState> profileKey = GlobalKey<ProfileSelectorState>();

  @override
  Widget build(BuildContext context) {
    return Center(child: ProfileSelector(key: profileKey, size: 100, imageUrl: "https://some/image")); // add key parameters
    // return ProfileSelector(key: profileKey, size: 100, imageFile: File("some/file"), changeable: false);
  }

  dynamic somewhereElse() async{
    // URL provided AND no manual selection => URL
    // imageFile provided OR manual selection => File
    // no URL AND no image selected => null

    // in this scenario will return URL if URL is provided in creation of widget and user has not selected image manually
    dynamic retrivedImage = await profileKey.currentState?.getImage();
    // if imageFile is provided or user has selected image, a File will be returned
    // else it will return null
  }
}