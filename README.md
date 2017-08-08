# Dustr
iOS mobile application that cleans up your social media presence and your photo album.

### Reminders for developers:
- If Xcode complains about a module not loaded, make sure the dependency is added to the Podfile and that you run "pod install" after to download the dependencies. 
- When added an Objective C bridging header if using Swift, make sure you go to Build Settings -> Swift Compiler - General -> Objective C Bridging Header and add the path to the bridging header, relative to the project. 
