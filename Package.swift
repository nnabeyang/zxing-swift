// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ZXingSwift",
    platforms: [
        .iOS(.v9),
    ],
    products: [
        .library(
            name: "ZXingSwift",
            targets: ["ZXingSwift"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ZXingSwift",
            dependencies: ["ZXingCpp"]),
        .target(
            name: "ZXingCpp",
            dependencies: ["ZXing"],
            linkerSettings: [.linkedLibrary("c++")]),
        .binaryTarget(
            name: "ZXing",
            url: "https://github.com/nnabeyang/zxing-cpp/releases/download/ios-v0.0.3/ZXing.xcframework.zip",
            checksum: "35e5b2f7ff6659dcc02a855531e76b6ffc645d13b98267cad567ca7d16f5cf9d"), 
        .testTarget(
            name: "ZXingSwiftTests",
            dependencies: ["ZXingSwift"]),        
    ]
)
