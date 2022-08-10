// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SearchBarNavigation",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SearchBarNavigation",
            targets: ["SearchBarNavigation"]),
    ],
    dependencies: [
        .package(name: "FWCommonProtocols", url: "https://github.com/franklynw/FWCommonProtocols.git", .upToNextMajor(from: "1.0.0")),
        .package(name: "ButtonConfig", url: "https://github.com/franklynw/ButtonConfig.git", .upToNextMajor(from: "3.0.0")),
        .package(name: "FWMenu", url: "https://github.com/franklynw/FWMenu.git", .upToNextMajor(from: "4.0.0"))
    ],
    targets: [
        .target(
            name: "SearchBarNavigation",
            dependencies: ["FWCommonProtocols", "ButtonConfig", "FWMenu"],
            resources: [.process("Resources/Example1.png"), .process("Resources/Example2.png"), .process("Resources/Example3.png")]),
        .testTarget(
            name: "SearchBarNavigationTests",
            dependencies: ["SearchBarNavigation"]),
    ]
)
