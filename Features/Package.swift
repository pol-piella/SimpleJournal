// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Capture", targets: ["Capture"])
    ],
    dependencies: [
        .package(name: "CameraService", path: "../Services")
    ],
    targets: [
        .target(
            name: "Capture",
            dependencies: ["CameraService"])
    ]
)
