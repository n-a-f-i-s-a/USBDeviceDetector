//
//  ContentView.swift
//  USBDeviceDetector
//
//  Created by Nafisa Rahman on 8/4/2023.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var usbViewModel: USBViewModel
    
    let usbConnectedPublisher = NotificationCenter.default.publisher(for: .connected)
    let usbDisconnectedPublisher = NotificationCenter.default.publisher(for: .disconnected)
    
    init(usbViewModel: USBViewModel) {
        self.usbViewModel = usbViewModel
    }
    
    var body: some View {
        Table(usbViewModel.detectedDevices) {
            TableColumn("Status") { device in
                if device.state {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .foregroundColor(.green)
                        .shadow(radius:3)
                        .frame(width: 35, height: 35)
                        .padding()
                }
            }
            TableColumn("Name", value: \.deviceName)
            TableColumn("ID") { device in
                Text(String(device.deviceID, radix:16))
            }
            TableColumn("Vendor") { device in
                Text(String(device.vendorID, radix:16))
            }
            TableColumn("Product") { device in
                Text(String(device.productID, radix:16))
            }
        }
        .onAppear{
            usbViewModel.startMonitoring()
        }
        .onDisappear {
            usbViewModel.stopMonitoring()
        }
        .onReceive(usbConnectedPublisher) { output in
            usbViewModel.onUsbConnected(output as NSNotification)
        }
        .onReceive(usbDisconnectedPublisher) { output in
            usbViewModel.onUsbDisconnected(output as NSNotification)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(usbViewModel: USBViewModel())
    }
}
