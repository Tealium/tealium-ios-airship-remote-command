// swift-tools-version:5.5
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
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", from: "2.5.0"),
        .package(name: "Airship", url: "https://github.com/urbanairship/ios-library", from: "16.0.1")
    ],
    targets: [
        .target(
            name: "TealiumAirship",
            dependencies: [
                .product(name: "AirshipCore", package: "Airship"),
                .product(name: "AirshipAutomation", package: "Airship"),
                .product(name: "AirshipMessageCenter", package: "Airship"),
                .product(name: "AirshipLocation", package: "Airship"),
                .product(name: "TealiumCore", package: "TealiumSwift"),
                .product(name: "TealiumRemoteCommands", package: "TealiumSwift")
            ],
            path: "./Sources"
        ), 
        .testTarget(
            name: "TealiumAirshipTests",
            dependencies: ["TealiumAirship"],
            path: "./Tests")
    ]
)
