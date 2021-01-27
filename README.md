# UnnaturalScrollWheels

![App Icon](/../master/UnnaturalScrollWheels/Assets.xcassets/AppIcon.appiconset/256x256.png?raw=true "App Icon")

Invert scroll direction for physical scroll wheels while maintaining "Natural" scrolling for trackpads on MacOS.

![Screenshot](/../master/Screenshots/Screenshot.png?raw=true "Screenshot")

## Why? What does it do?

For some reason in macOS, toggling the "Scroll direction: Natural" option in *Mouse* settings also changes it in *Trackpad* settings despite being in separate places.

![Mouse Settings](/../master/Screenshots/MouseSettings.png?raw=true "Mouse Settings")
![Trackpad Settings](/../master/Screenshots/TrackpadSettings.png?raw=true "Trackpad Settings")

This application makes it so that scroll direction for physical scroll wheels is the opposite of what is shown in settings without messing with the scroll direction of the trackpad.

The issue is described here:

https://apple.stackexchange.com/questions/116617/how-to-separate-mouse-and-trackpad-settings

Unfortunately most/all solutions no longer work reliably if at all in Catalina.

## Installation

### Using Homebrew

```
brew install --cask unnaturalscrollwheels
```

### Manual download

1. Download the latest `.dmg` from the [releases page](/../../releases), mount it, and copy the `.app` to your applications folder like any other application.

2. The application is not notarized since I haven't paid the yearly $100 fee to join the Apple Developer Program, you will need to right click on the `.app` and choose Open.

![Open Application](/../master/Screenshots/OpenApplication.png?raw=true "Open Application")

3. The app requires accessibility permissions to "Control your computer". This is required to intercept scroll events, invert them and modify their deltas to disable acceleration and apply your settings.

![Accessibility Popup](/../master/Screenshots/AccessibilityPopup.png?raw=true "Accessibility Popup")

![Accessibility Settings](/../master/Screenshots/AccessibilitySettings.png?raw=true "Accessibility Settings")

That's it!

## Usage

For the most part, things are self explanatory. One possible point of confusion may be how to modify your preferences once you've hidden the app from menu bar. To show preferences and to temporarily show the menu bar icon again, with the application running the background, simply open the application again which will display the preferences window.

## Run at login

[See here](/../master/RunAtLogin.md)
