
import Cocoa

class AutoLauncherAppDelegate: NSObject, NSApplicationDelegate {
    
    struct Constants {
        static let mainAppBundleID = "com.theron.UnnaturalScrollWheels"
        static let mainAppName = "UnnaturalScrollWheels.app"
    }

    /// Finds the main app whether the helper is running from the installed bundle
    /// (Contents/Library/LoginItems) or directly from Xcode's DerivedData products.
    private func locateMainApp() -> URL? {
        let helperURL = Bundle.main.bundleURL
        let fileManager = FileManager.default

        // Installed app location
        let bundledAppURL = helperURL
            .deletingLastPathComponent() // LoginItems
            .deletingLastPathComponent() // Library
            .deletingLastPathComponent() // Contents
            .deletingLastPathComponent() // UnnaturalScrollWheels.app

        // Xcode debug location (same build products folder as the helper)
        let debugAppURL = helperURL
            .deletingLastPathComponent()
            .appendingPathComponent(Constants.mainAppName)

        let candidates = [bundledAppURL, debugAppURL]
        for url in candidates where url.pathExtension == "app" {
            if fileManager.fileExists(atPath: url.path) {
                return url
            }
        }

        // Fallback to whatever copy of the app LaunchServices knows about.
        return NSWorkspace.shared.urlForApplication(withBundleIdentifier: Constants.mainAppBundleID)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let runningApps = NSWorkspace.shared.runningApplications
        let isRunning = runningApps.contains {
            $0.bundleIdentifier == Constants.mainAppBundleID
        }
        
        if !isRunning {
            guard let mainAppURL = locateMainApp() else { return }

            NSWorkspace.shared.openApplication(at: mainAppURL,
                                               configuration: NSWorkspace.OpenConfiguration(),
                                               completionHandler: nil)
        }
    }
    
}
