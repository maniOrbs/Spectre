// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Spectre",
    products: [
        .library(name: "Spectre",targets: ["Spectre"]),
    ],
    targets: [
        .target(
            name: "Spectre"),
        .testTarget(name: "SpectreTests",dependencies: ["Spectre"]),
    ]
)
