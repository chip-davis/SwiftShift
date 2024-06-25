//
//  SaveManager.swift
//  Swift Shift
//
//  Created by Chip Davis on 6/25/24.
//

import Foundation

class SaveManager {
    static func save(apps: [WindowInfo], category: String) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(apps)
            
            UserDefaults.standard.set(data, forKey: category)
            
        } catch {
            print("Could not save")
        }
        
    }
    
    static func load(category: String) -> [WindowInfo] {
        var apps: [WindowInfo] = []
        if let data = UserDefaults.standard.data(forKey: category) {
            do {
                let decoder = JSONDecoder()
                
                apps = try decoder.decode([WindowInfo].self, from: data)
                
            } catch {
                print("Unable to Decode \(error)")
            }
        }
        return apps
    }
    
}
