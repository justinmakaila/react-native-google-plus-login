###Installation
1. Download the [Google+ SDK](https://developers.google.com/+/mobile/ios/getting-started) for iOS and follow the instructions to install it on your project.
2. `npm install --save react-native-google-plus-login`
3. Add `RCTGooglePlusLogin.xcodeproj` to your project
4. Link `libRCTGooglePlusLogin.a` to your project 
  4a. Add `libRCTGooglePlusLogin.a` to the "Link With Binary Libraries" section of "Build Phases".
5. Open the `RCTGooglePlusLogin.xcodeproj build settings` and ensure that "Framework Search Paths" points to the location of the Google+ SDK
6. Build and run.

File an issue if you have any problems. 
