//
//  USBDeviceDetectorApp.swift
//  USBDeviceDetector
//
//  Created by Nafisa Rahman on 8/4/2023.
//

import SwiftUI

@main
struct USBDeviceDetectorApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(usbViewModel: USBViewModel())
        }
    }
}
