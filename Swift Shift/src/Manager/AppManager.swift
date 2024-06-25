import Foundation
import Cocoa

class AppManager {
    
    static func openApp(app: WindowInfo, timeout: TimeInterval = 10) {
        let workspace = NSWorkspace.shared
        let configuration = NSWorkspace.OpenConfiguration()
        
        // Get the running applications
        let runningApps = workspace.runningApplications
        
        // Check if the application is already running
        if let runningApp = runningApps.first(where: { $0.bundleURL == app.url }) {
            handleRunningApp(app: app, runningApp: runningApp)
        } else {
            // If not running, open the application
            workspace.openApplication(at: app.url, configuration: configuration) { (openedApp, error) in
                if let error = error {
                    print("Error opening application: \(error.localizedDescription)")
                } else {
                    print("Successfully initiated opening of application: \(openedApp?.localizedName ?? "")")
                    self.waitForAppToBeReady(app: app, openedApp: openedApp, timeout: timeout)
                }
            }
        }
    }
    
    private static func waitForAppToBeReady(app: WindowInfo, openedApp: NSRunningApplication?, timeout: TimeInterval) {
        let startTime = Date()
        
        func check() {
            guard let openedApp = openedApp else { return }
            
            if Date().timeIntervalSince(startTime) > timeout {
                print("Timeout waiting for app to be ready")
                return
            }
            
            let appElement = WindowManager.createAXUIElement(for: openedApp.processIdentifier)
            var windowsRef: CFTypeRef?
            
            if AXUIElementCopyAttributeValue(appElement, kAXWindowsAttribute as CFString, &windowsRef) == .success,
               let windows = windowsRef as? [AXUIElement],
               !windows.isEmpty {
                // App is ready, handle it
                self.handleRunningApp(app: app, runningApp: openedApp)
            } else {
                // App is not ready yet, check again after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    check()
                }
            }
        }
        
        // Start checking
        check()
    }
    private static func handleRunningApp(app: WindowInfo, runningApp: NSRunningApplication) {
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
            
            // Resize the window
            WindowManager.resize(window: firstWindow, to: CGSize(width: updatedApp.bounds.width, height: updatedApp.bounds.height), from: updatedApp.coordinates)
            
            // Bring the window to the foreground
            WindowManager.focus(window: firstWindow)
            
            print("\(runningApp.localizedName ?? "") has been repositioned and resized.")
        } else {
            print("Failed to get windows for \(runningApp.localizedName ?? "")")
        }
    }
}
