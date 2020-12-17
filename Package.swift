// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "TealiumAirship",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "TealiumAirship", targets: ["TealiumAirship"]),
        .library(name: "TealiumAirship_Location", targets: ["TealiumAirship_Location"])
    ],
    dependencies: [
        .package(url: "https://github.com/tealium/tealium-swift", from: "2.2.0"),
        .package(url: "https://github.com/urbanairship/ios-library", from: "14.1.0")
    ],
    targets: [
        .target(
            name: "TealiumAirship",
            dependencies: ["Airship", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement"],
            path: "./Sources", 
            exclude: ["AirshipLocation.swift"]),
        .target(
            name: "TealiumAirship_Location",
            dependencies: ["Airship", "AirshipLocation", "TealiumCore", "TealiumRemoteCommands", "TealiumTagManagement"],
            path: "./Sources/Location"),
        .testTarget(
            name: "TealiumAirshipTests",
            dependencies: ["TealiumAirship"],
            path: "./Tests")
    ]
)
