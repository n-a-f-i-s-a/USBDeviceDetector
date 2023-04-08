//
//  USBMonitor.swift
//  USBDeviceChecker
//
//  Created by Nafisa Rahman on 8/4/2023.
//

import Foundation
import IOKit
import IOKit.usb

public extension Notification.Name {
    static let connected = Notification.Name("Connected")
    static let disconnected = Notification.Name("Disconnected")
}

final class USBMonitorService {
    private var vendorID: Int
    private var productID: Int
    private var notificationPort: IONotificationPortRef?
    private var deviceAddedIterator: io_iterator_t = 0
    private var deviceRemovedIterator: io_iterator_t = 0
    
    init(vendorID: Int, productID: Int) {
        self.vendorID = vendorID
        self.productID = productID
    }
    
}

extension USBMonitorService {
    
    func startMonitoring() {
        self.notificationPort = IONotificationPortCreate(kIOMainPortDefault)

        // dictionary to match product and vendor id of a USB device class
        var matchedUSBDeviceDictionary = IOServiceMatching(kIOUSBDeviceClassName) as! [String : AnyObject]
        
        // Set the vendor ID to match
        let cfUSBVendor = CFNumberCreate(nil, CFNumberType.intType, &self.vendorID)!
        matchedUSBDeviceDictionary[kUSBVendorID] = cfUSBVendor
        
        // Set the product IDs to match
        let cfUSBProduct = CFNumberCreate(nil, CFNumberType.intType, &self.productID)!
        matchedUSBDeviceDictionary[kUSBProductID] = cfUSBProduct
        
        let cfServiceMatchingDictionary = matchedUSBDeviceDictionary as CFDictionary
        let selfPointer = Unmanaged.passUnretained(self).toOpaque()

        func handleUSBEvents(context: UnsafeMutableRawPointer?, _ iterator: io_iterator_t) {
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200), execute: {
                let usbMonitor = Unmanaged<USBMonitorService>.fromOpaque(context!).takeUnretainedValue()
                switch iterator {
                case usbMonitor.deviceAddedIterator:
                    usbMonitor.handleAddUSBEvent(iterator: iterator)
                case usbMonitor.deviceRemovedIterator:
                    usbMonitor.handleRemoveUSBEvent(iterator: iterator)
                default:
                    break
                }
            })
        }

        IOServiceAddMatchingNotification(
            self.notificationPort,
            kIOFirstMatchNotification,
            cfServiceMatchingDictionary,
            handleUSBEvents,
            selfPointer,
            &self.deviceAddedIterator
        )
        
        handleUSBEvents(context: selfPointer, self.deviceAddedIterator)
        
        IOServiceAddMatchingNotification(
            self.notificationPort,
            kIOTerminatedNotification,
            cfServiceMatchingDictionary,
            handleUSBEvents,
            selfPointer,
            &self.deviceRemovedIterator
        )
        
        handleUSBEvents(context: selfPointer, self.deviceRemovedIterator)
 
        CFRunLoopAddSource(
            CFRunLoopGetCurrent(),
            IONotificationPortGetRunLoopSource(self.notificationPort).takeRetainedValue(),
            CFRunLoopMode.commonModes
        )
    }
    
    func stopMonitoring() {
        IOObjectRelease(self.deviceAddedIterator)
        IOObjectRelease(self.deviceRemovedIterator)

        CFRunLoopRemoveSource(
            CFRunLoopGetCurrent(),
            IONotificationPortGetRunLoopSource(self.notificationPort).takeRetainedValue(),
            CFRunLoopMode.commonModes
        )
        
        self.notificationPort = nil
    }
    
}

private extension USBMonitorService {

    func handleAddUSBEvent(iterator: io_iterator_t) {
        while case let usbDevice = IOIteratorNext(iterator), usbDevice != 0 {
            var usbDeviceID:UInt64 = 0
            
            guard IORegistryEntryGetRegistryEntryID(usbDevice, &usbDeviceID) == kIOReturnSuccess else {
                continue
            }
            
            var registryEntryName:[CChar] = [CChar](repeating: 0, count: 128)
            
            guard IORegistryEntryGetName(usbDevice, &registryEntryName) == kIOReturnSuccess else {
                continue
            }

            NotificationCenter.default.post(
                name: .connected,
                object: [
                    "deviceId": usbDeviceID,
                    "vendorId": self.vendorID,
                    "productId" : self.productID,
                    "deviceName": String.init(cString: &registryEntryName)
                ] as [String : Any])
            
            guard IOObjectRelease(usbDevice) == kIOReturnSuccess else {
                continue
            }
        }
    }
    
    func handleRemoveUSBEvent(iterator: io_iterator_t) -> Void {
        while case let usbDevice = IOIteratorNext(iterator), usbDevice != 0 {
            var usbDeviceID:UInt64 = 0
            
            guard IORegistryEntryGetRegistryEntryID(usbDevice, &usbDeviceID) == kIOReturnSuccess else {
                continue
            }

            guard IOObjectRelease(usbDevice) == kIOReturnSuccess else {
                continue
            }
            
            NotificationCenter.default.post(
                name: .disconnected,
                object: [
                    "deviceId": usbDeviceID,
                    "vendorId": self.vendorID,
                    "productId" : self.productID,
                ] as [String : Any])
        }
    }
    
}
