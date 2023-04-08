//
//  USBModel.swift
//  USBDeviceChecker
//
//  Created by Nafisa Rahman on 8/4/2023.
//

import Foundation

struct USBDevice: Identifiable {
    let id = UUID()
    let deviceID: UInt64
    let vendorID: Int
    let productID: Int
    let deviceName: String
    let state: Bool
}
