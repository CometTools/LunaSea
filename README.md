[![Subreddit](https://img.shields.io/reddit/subreddit-subscribers/LunaSeaApp?label=Subreddit&logo=reddit&logoColor=white&style=for-the-badge)](https://www.reddit.com/r/LunaSeaApp)
&nbsp; [![Feedback](https://img.shields.io/badge/Feedback-Nolt-red?style=for-the-badge&logo=app-store&color=%234ECCA3&logoColor=white)](https://feedback.lunasea.app)
&nbsp; [![App Store](https://img.shields.io/badge/App%20Store-v2.1.0%20(66)-red?style=for-the-badge&logo=app-store&color=%230D96F6&logoColor=white)](https://apps.apple.com/us/app/lunasea/id1496797802?ls=1)
&nbsp; [![Play Store](https://img.shields.io/badge/Google%20Play-v2.1.0%20(66)-red?style=for-the-badge&logo=google-play&color=%230F9D58&logoColor=white)](https://play.google.com/store/apps/details?id=app.lunasea.lunasea)

![LunaSea](https://www.lunasea.app/images/banner.png)

![Screenshot](https://www.lunasea.app/images/hero.png)

LunaSea is a fully featured, open source self-hosted media manager! Focused on giving you a seamless experience between all of your self-hosted media software, LunaSea supports:

- Lidarr
- Radarr
- Sonarr
- SABnzbd
- NZBGet
- Newznab Indexer Searching

LunaSea even comes with support for multiple instances of applications using profiles, backing up and restoring your configuration to your filesystem, an AMOLED black theme, and more!

> Please note that LunaSea is purely a remote control application, it does not offer any functionality without software installed on a server/computer.

---

## Developing, Installing, &amp; Building (iOS)

#### Requirements

1. A MacOS Machine
2. An AppleID account (does not require developer account)
3. [Flutter Framework (Beta Channel)](https://flutter.dev/)
4. [XCode 11.4 or Higher](https://apps.apple.com/ca/app/xcode/id497799835?mt=12)
5. [Developer Certificate Configured](https://github.com/LunaSeaApp/LunaSea/wiki/Setup-of-Development-Certificate)

#### Developing

1. Clone the repository
    - `git clone git@github.com:LunaSeaApp/LunaSea.git`
2. Install the Flutter packages
    - `flutter pub get`
3. Start your simulator or plug in your device and ensure you have accepted it is a trusted device
4. Install LunaSea in development mode on your device or simulator
    - `flutter run` 

#### Installing

> Release builds can only be installed on physical devices

1. Clone the repository
    - `git clone git@github.com:LunaSeaApp/LunaSea.git`
2. Install the Flutter packages
    - `flutter pub get`
3. Plug in your device and ensure you have accepted it is a trusted device
4. Install a production version of the application on your device
    - `flutter run --release`

#### Building (.ipa)

1. Clone the repository
    - `git clone git@github.com:LunaSeaApp/LunaSea.git`
2. Install the Flutter packages
    - `flutter pub get`
3. Run `build_ipa` inside of the `scripts` folder
4. The IPA will be placed in the root of the project directory

---

## Developing, Installing, &amp; Building (Android)

#### Requirements

1. Android SDK/Android Studio Installed & Configured
2. [Flutter Framework (Beta Channel)](https://flutter.dev/)
3. [Keystore Configured](https://github.com/LunaSeaApp/LunaSea/wiki/Configure-Keystore)

#### Developing

1. Clone the repository
    - `git clone git@github.com:LunaSeaApp/LunaSea.git`
2. Install the Flutter packages
    - `flutter pub get`
3. Start your simulator or plug in your device and ensure you have enabled USB Debugging
4. Install LunaSea in development mode on your device or simulator
    - `flutter run` 

#### Installing

> Release builds can only be installed on physical devices

1. Clone the repository
    - `git clone git@github.com:LunaSeaApp/LunaSea.git`
2. Install the Flutter packages
    - `flutter pub get`
3. Plug in your device and ensure you have enabled USB Debugging
4. Install a production version of the application on your device
    - `flutter run --release`

#### Building (.apk)

1. Clone the repository
    - `git clone git@github.com:LunaSeaApp/LunaSea.git`
2. Install the Flutter packages
    - `flutter pub get`
3. Run `flutter build apk --split-per-abi`
4. The APKs are located in:
    - `./build/app/outputs/apk/release/app-armeabi-v7a-release.apk`
    - `./build/app/outputs/apk/release/app-arm64-v8a-release.apk`
    - `./build/app/outputs/apk/release/app-x86_64-release.apk`
