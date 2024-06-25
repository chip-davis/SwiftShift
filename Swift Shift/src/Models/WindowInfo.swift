//
//  WindowInfo.swift
//  Swift Shift
//
//  Created by Chip Davis on 6/23/24.
//

import Foundation
import CoreGraphics

struct WindowInfo: Codable {
    var alpha: Float
    var bounds: CGRect
    var isOnscreen: Bool
    var layer: Int
    var memoryUsage: Int
    var number: Int
    var ownerName: String
    var ownerPID: Int
    var sharingState: Int
    var storeType: Int
    var url: URL

    init?(dict: [String: Any]) {
        guard let alpha = dict["kCGWindowAlpha"] as? Float,
              let boundsDict = dict["kCGWindowBounds"] as? [String: CGFloat],
              let isOnscreen = dict["kCGWindowIsOnscreen"] as? Int,
              let layer = dict["kCGWindowLayer"] as? Int,
              let memoryUsage = dict["kCGWindowMemoryUsage"] as? Int,
              let number = dict["kCGWindowNumber"] as? Int,
              let ownerName = dict["kCGWindowOwnerName"] as? String,
              let ownerPID = dict["kCGWindowOwnerPID"] as? Int,
              let sharingState = dict["kCGWindowSharingState"] as? Int,
              let storeType = dict["kCGWindowStoreType"] as? Int else {
            return nil
        }

        self.alpha = alpha
        self.bounds = CGRect(
            x: boundsDict["X"] ?? 0,
            y: boundsDict["Y"] ?? 0,
            width: boundsDict["Width"] ?? 0,
            height: boundsDict["Height"] ?? 0
        )
        self.isOnscreen = isOnscreen == 1
        self.layer = layer
        self.memoryUsage = memoryUsage
        self.number = number
        self.ownerName = ownerName
        self.ownerPID = ownerPID
        self.sharingState = sharingState
        self.storeType = storeType
        if let pid = dict[kCGWindowOwnerPID as String] as? pid_t {
            self.url = WindowManager.getUrlForApp(with: pid) ?? URL(fileURLWithPath: "/")
            } else {
                self.url = URL(fileURLWithPath: "/")
            }
    }
}

