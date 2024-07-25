// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GenericNetworkLayer",
    platforms: [
      .iOS(.v14),
      .macOS(.v11),
      .watchOS(.v4)
    ],
    products: [
        .library(
            name: "GenericNetworkLayer",
            targets: ["GenericNetworkLayer"]),
    ],
    targets: [
        .target(
            name: "GenericNetworkLayer"),
        .testTarget(
            name: "GenericNetworkLayerTests",
            dependencies: ["GenericNetworkLayer"]),
    ]
)
