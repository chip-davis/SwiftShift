import Foundation
import Cocoa

class AppManager {
    
    static func openApp(app: WindowInfo) {
        let workspace = NSWorkspace.shared
        let configuration = NSWorkspace.OpenConfiguration()
        
        // Get the running applications
        let runningApps = workspace.runningApplications
        
        // Check if the application is already running
        if let runningApp = runningApps.first(where: { $0.bundleURL == app.url }) {
            var updatedApp = app
            updatedApp.updateOwnerPID(newPID: Int(runningApp.processIdentifier))
            let appElement = WindowManager.createAXUIElement(for: pid_t(updatedApp.ownerPID))
            
            var windowsRef: CFTypeRef?
            if AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef) == .success,
               let windows = windowsRef as? [AXUIElement],
               let firstWindow = windows.first {
                
                // Check if the window is minimized
                var minimizedRef: CFTypeRef?
                AXUIElementCopyAttributeValue(firstWindow, kAXMinimizedAttribute as CFString, &minimizedRef)
                let isMinimized = (minimizedRef as? Bool) ?? false
                
                if isMinimized {
                    // Unminimize the window
                    AXUIElementSetAttributeValue(firstWindow, kAXMinimizedAttribute as CFString, false as CFTypeRef)
                }
                
                // Move the window
                WindowManager.move(window: firstWindow, to: updatedApp.coordinates)
                
                // Bring the window to the foreground
                WindowManager.focus(window: firstWindow)
                
                print("\(runningApp.localizedName ?? "") is already running and has been repositioned.")
            } else {
                print("Failed to get windows for \(runningApp.localizedName ?? "")")
            }
            
        } else {
            // If not running, open the application
            workspace.openApplication(at: app.url, configuration: configuration) { (openedApp, error) in
                if let error = error {
                    print("Error opening application: \(error.localizedDescription)")
                } else {
                    print("Successfully opened application: \(openedApp?.localizedName ?? "")")
                    // You might want to add a delay here and then try to move the window
                    // as the app might need some time to create its windows
                }
            }
        }
    }
}
