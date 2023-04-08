# Description

This `SwiftUI` app is designed to detect any connected USB devices `matching` a given `Vendor ID` and `Product ID` and display their corresponding details in an organized table view. 

Once the app is launched and detects a matching USB device (already connected before starting app and/or during runtime), it will automatically retrieve and display the device's name, unique identification number, product identification number, and vendor identification number.

These details will be displayed in a clean and easy-to-read table format, making it simple for users to quickly identify and keep track of all connected USB devices. With its intuitive design and efficient functionality, this app is an excellent tool for anyone who needs to manage multiple USB devices simultaneously.


# Screenshot

<img width="1012" alt="Screenshot 2023-04-08 at 6 24 53 pm" src="https://user-images.githubusercontent.com/61398249/230711905-88e5d34c-343d-44a2-b1ac-f24928cd1404.png">

A SwiftUI app that detects connected USB devices and displays the device name, ID, product ID, and vendor ID in a table. The app uses the USBMonitorService class to monitor USB events.

## Requirements

- Xcode 14.3 or later
- Swift 5.8 or later
- [Device used for test](https://www.jaycar.com.au/arduino-compatible-usb-to-serial-adaptor-module/p/XC4464?gclid=Cj0KCQjwocShBhCOARIsAFVYq0hM8zdo2Mwn6nDH5BbB2Iilcjp8BMe2yFwYxNo-ykoN2mhDdSrdmK0aAlTHEALw_wcB)

## Installation

1. Clone the repository:
```
git clone https://github.com/yourusername/USBDeviceChecker.git
```

2. Open USBDeviceChecker.xcodeproj in Xcode.
3. Build and run the app.


# Usage

When you launch the app, it will start monitoring USB devices. If a device that matches the vendor ID and product ID specified in USBMonitorService is connected or disconnected, the app will display the device name, ID, product ID, and vendor ID in a table.

To stop monitoring USB devices, tap the "Stop" button in the top right corner of the app.

# License

This app is released under the MIT License. See LICENSE for details.

# Acknowledgments

This app uses the IOKit and IOKit.usb frameworks to monitor USB events.
