# Flutter Profile Image Selector

## Prerequisites

#### iOS

Add following into `Info.plist` in `ios/Runner` for photo library access

```xml
<dict>
    .......
	<key>NSPhotoLibraryUsageDescription</key>
	<string>Photo Library Access Warning</string>
    .......
</dict>
```

#### Android

Add following into `AndoidManifest.xml` inside the `application` tag

```xml
        <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar"/>
```

### Dependencies

Add these into `pubspec.yaml`

```yaml
dependencies:
  cupertino_icons: ^1.0.8
  image_picker: ^1.1.2
  image_cropper: ^8.0.2
  path_provider: ^2.1.5
  http: ^1.2.2
```

## Usage
If you don't want to get the image that has been shown or selected on the profile but just showing a circle profile, then simply use this

```dart
import 'profile_selector.dart';

class YourView extends StatefulWidget {
  const YourView({super.key});

  @override
  State<YourView> createState() => _YourViewState();
}

class _YourViewState extends State<YourView> {
  @override
  Widget build(BuildContext context) {
    return ProfileSelector(size: 100, imageUrl: "https://some/image", changeable: false);
    // return ProfileSelector(size: 100, imageFile: File("some/file"), changeable: false);
  }
}
```

If you want to retrieve image/URL in the circle profile, follow this steps or check the `example/lib/main.dart`

```dart
import 'profile_selector.dart';

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
    return ProfileSelector(key: profileKey, size: 100, imageUrl: "https://some/image"); // add key parameters
    // return ProfileSelector(size: 100, imageFile: File("some/file"), changeable: false);
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
```