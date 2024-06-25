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
            
        workspace.openApplication(at: app.url, configuration: configuration) { (app, error) in
                if let error = error {
                    print("Error opening application: \(error.localizedDescription)")
                } else {
                    print("Successfully opened application: \(app?.localizedName ?? "")")
                }
            }
        }
    
}
