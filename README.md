# BuyBuddy Apple Software Development Kit

Lead maintainers: [Emir Çiftçioğlu (eciftcioglu)](https://github.com/eciftcioglu/), [Buğra Ekuklu (Chatatata)](https://github.com/Chatatata/).

The BuyBuddy Apple Devices Software Development Kit makes your application to integrate easily with BuyBuddy platform to create astonishing shopping experience. 
This library provides a generic abstraction layer to access BuyBuddy platform in a modular way.

To get started, navigate to [Apple Devices Integration Guide](https://github.com/heybuybuddy/BuyBuddyKit/).

### Features
- **Device management**: Dealing with BuyBuddy licensed devices has become easier with our asynchronous device management API. We want to remove your concerns while using a Bluetooth Low Energy® (BLE) device in your application.
- **Platform management**: An object-oriented abstraction of platform management to not deal with underlying HATEOAS API. Every single entity found in our platform can be managed with this library.
- **Simplified payments**: You might use your own payment system, or you can use existing ones found in APIs.
- **Toll-free bridging**: This framework is also used by our [open-source management application](https://github.com/heybuybuddy/Manager-macOS/). We offer toll-free bridging between clients and our web services, which means you can use every feature found in our licensed applications.
- **Core Data support**: You may use our seperate [Core Data wrapper library](https://github.com/heybuybuddy/BuyBuddyKitCoreDataWrapper) if you want *first-class* support for offline persistence.

## Installation
Our software development kit supports various installation methods.

### Embedded Framework
- Roll a new terminal and change your current working directory to the root of your project directory.

- If your project is not git repository, instantiate a new one by running command:

  ```bash
  $ git init
  ```
  
- Add *BuyBuddyKit* as a git [submodule](http://git-scm.com/docs/git-submodule) by running the following command:

  ```bash
  $ git submodule add https://github.com/heybuybuddy/BuyBuddyKit.git Library/BuyBuddyKit
  ```
  
- Open the new `BuyBuddyKit` folder, and drag the `BuyBuddyKit.xcodeproj` into the Project Navigator of your application's Xcode project.
    > It should appear nested underneath your application's blue project icon. Whether it is above or below all the other Xcode groups does not matter.
  
- Select the `BuyBuddyKit.xcodeproj` in the Project Navigator and verify the deployment target matches that of your application target.

- Select your application project in the Project Navigator (blue project icon) to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.

- In the tab bar at the top of that window, open the "General" panel.

- Click on the `+` button under the "Embedded Binaries" section.

- You will see two different `BuyBuddyKit.xcodeproj` folders each with two different versions of the `BuyBuddyKit.framework` nested inside a `Products` folder.
    > It does not matter which `Products` folder you choose from, but it does matter whether you choose the top or bottom `BuyBuddyKit.framework`.
    
- Select the top `BuyBuddyKit.framework` for iOS and the bottom one for macOS.
    > You can verify which one you selected by inspecting the build log for your project. The build target for `BuyBuddyKit` will be listed as either `BuyBuddyKit iOS`, `BuyBuddyKit macOS`, `BuyBuddyKit tvOS` or `BuyBuddyKit watchOS`.

- And that's it!
    > The `BuyBuddyKit.framework` is automagically added as a target dependency, linked framework and embedded framework in a copy files build phase which is all you need to build on the simulator and a device.
    
### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. 
You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 1.1+ is required to build BuyBuddyKit 2.0+.

To integrate BuyBuddyKit into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'BuyBuddyKit', '~> 2.0'
end
```

Then, run the following command:

```bash
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate BuyBuddyKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "heybuybuddy/BuyBuddyKit" ~> 2.0
```

Run `carthage update` to build the framework and drag the built `BuyBuddyKit.framework` into your Xcode project.

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler. 
It is in early development, but BuyBuddyKit does support its use on supported platforms. 

Once you have your Swift package set up, adding BuyBuddyKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .Package(url: "https://github.com/heybuybuddy/BuyBuddyKit.git", majorVersion: 2)
]
```

## Support
BuyBuddy engineering team is always ready to support you.

### Contributing
All contributions are welcomed, you may open issues or pull requests regarding bug (or bug fixes), new features, or improvements and clarifications in documentations.
We really try hard to make everything found (including HTTP web services) in our platform open source, hence we expect patience from you while everything is going to be eligible.

Finally, please read our [Code of Conduct](https://github.com/heybuybuddy/BuyBuddyKit/blob/refactor/CODE_OF_CONDUCT.md).

### Running Unit Tests
1. Clone the repository to your local: `git clone https://github.com/heybuybuddy/BuyBuddyKit/`.
2. Open `BuyBuddyKit.xcodeproj`.
3. Select corresponding scheme for your platform.
4. Run `Test` target.

## Attributions

We apprecicate the efforts of the communities of [Alamofire](https://github.com/Alamofire/Alamofire), [AFNetworking](https://github.com/AFNetworking/AFNetworking) and [Stripe](https://stripe.com) to providing lean frameworks to teach us how a Objective-C/Swift library should be constituted.

## License
MIT