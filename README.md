# UnnaturalScrollWheels

![App Icon](/../master/UnnaturalScrollWheels/Assets.xcassets/AppIcon.appiconset/512x512.png?raw=true "App Icon")

Invert scroll direction for physical scroll wheels while maintaining "Natural" scrolling for trackpads on MacOS.

## Why? What does it do?

For some reason in macOS, toggling the "Scroll direction: Natural" option in *Mouse* settings also changes it in *Trackpad* settings despite being in separate places.

![Mouse Settings](/../master/Screenshots/MouseSettings.png?raw=true "Mouse Settings")
![Trackpad Settings](/../master/Screenshots/TrackpadSettings.png?raw=true "Trackpad Settings")

This application makes it so that scroll direction for physical scroll wheels is the opposite of what is shown in settings without messing with the scroll direction of the trackpad.

The issue is described here:

https://apple.stackexchange.com/questions/116617/how-to-separate-mouse-and-trackpad-settings

Unfortunately most/all solutions no longer work reliably if at all in Catalina, or offer much more functionality/bloat than you may want. This application solves the issue and is only mere kilobytes in size.

## Run at login

[See here](/../master/RunAtLogin.md)
