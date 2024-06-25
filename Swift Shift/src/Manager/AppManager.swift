//
//  AppManager.swift
//  Swift Shift
//
//  Created by Chip Davis on 6/25/24.
//

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
            print("\(runningApp.localizedName ?? "") is already running.")
            
        } else {
            // If not running, open the application
            workspace.openApplication(at: app.url, configuration: configuration) { (app, error) in
                if let error = error {
                    print("Error opening application: \(error.localizedDescription)")
                } else {
                    print("Successfully opened application: \(app?.localizedName ?? "")")
                }
            }
        }
    }
    

    
}
