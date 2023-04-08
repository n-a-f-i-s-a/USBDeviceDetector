//
//  ViewModel.swift
//  USBDeviceChecker
//
//  Created by Nafisa Rahman on 8/4/2023.
//

import Foundation
import SwiftUI

final public class USBViewModel: ObservableObject {
    
    // MARK: - Property

    private var usbMonitor: USBMonitorService?
    @Published var detectedDevices: [USBDevice]
    
    init() {
        usbMonitor = USBMonitorService(vendorID: Int(0x0403), productID: Int(0x6001))
        detectedDevices = []
    }
}

extension USBViewModel {
    
    func startMonitoring() {
        usbMonitor?.startMonitoring()
    }
    
    func stopMonitoring() {
        usbMonitor?.stopMonitoring()
    }
    
    func onUsbConnected(_ notification: NSNotification) {
        guard let postingObject = notification.object as? NSDictionary else {
            return
        }
        
        guard let deviceName = postingObject["deviceName"] as? String,
              let deviceId = postingObject["deviceId"] as? UInt64,
              let vendorId = postingObject["vendorId"] as? Int,
              let productId = postingObject["productId"] as? Int
        else {
            return
        }
        
        self.detectedDevices.append(
            USBDevice(
                deviceID: deviceId,
                vendorID: vendorId,
                productID: productId,
                deviceName: deviceName,
                state: true
            )
        )
    }
    
    func onUsbDisconnected(_ notification: NSNotification) {
        guard let postingObject = notification.object as? NSDictionary else {
            return
        }
        
        guard let deviceId = postingObject["deviceId"] as? Int else {
            return
        }
        
        guard let index = self.detectedDevices.firstIndex(where: {$0.deviceID == deviceId}) else {
            return
        }
        self.detectedDevices.remove(at: index)
    }
    
}
