// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TealiumAirship",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "TealiumAirship", targets: ["TealiumAirship"]),
    ],
    dependencies: [
        .package(name: "TealiumSwift", url: "https://github.com/tealium/tealium-swift", .upToNextMajor(from: "2.12.0")),
        .package(name: "Airship", url: "https://github.com/urbanairship/ios-library", .upToNextMajor(from: "16.0.1"))
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
            path: "./Sources",
            exclude: ["Support"]
        ), 
        .testTarget(
            name: "TealiumAirshipTests",
            dependencies: ["TealiumAirship"],
            path: "./Tests",
            exclude: ["Support"])
    ]
)
