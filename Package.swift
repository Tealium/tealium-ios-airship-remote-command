// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TealiumAirship",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "TealiumAirship", targets: ["TealiumAirship"])
        .library(name: "TealiumAirshipLocation", targets: ["TealiumAirshipLocation"])
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.2.0"),
        .package(url: "https://github.com/urbanairship/ios-library", from: "14.1.0")
    ],
    targets: [
        .target(
            name: "TealiumAirship",
            dependencies: ["Airship", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement"],
            path: "./Sources"),
        .target(
            name: "TealiumAirshipLocaion",
            dependencies: ["Airship", "AirshipLocation", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement"],
            path: "./Sources"),
        .testTarget(
            name: "TealiumAirshipTests",
            dependencies: ["TealiumAirship"],
            path: "./Tests")
    ]
)