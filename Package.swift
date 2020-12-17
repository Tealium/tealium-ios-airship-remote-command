// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TealiumAirship",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "TealiumAirship", targets: ["TealiumAirship"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.2.0"),
        .package(url: "https://github.com/urbanairship/ios-library", from: "14.1.0")
    ],
    targets: [
        .target(
            name: "TealiumAirship",
            dependencies: [
                "AirshipCore",
                "AirshipAutomation",
                "AirshipMessageCenter",
                "AirshipLocation",
                "TealiumCore",
                "TealiumRemoteCommands",
                "TealiumTagManagement"
            ],
            path: "./Sources"
        ), 
        .testTarget(
            name: "TealiumAirshipTests",
            dependencies: ["TealiumAirship"],
            path: "./Tests")
    ]
)
