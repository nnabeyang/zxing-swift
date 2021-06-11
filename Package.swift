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
            url: "https://github.com/nnabeyang/zxing-cpp/releases/download/ios-v0.0.1/ZXing.xcframework.zip",
            checksum: "3c7f15739219281d78f5eb47cafdfccb978321b1d24f898d968761a847545c91"),
        .testTarget(
            name: "ZXingSwiftTests",
            dependencies: ["ZXingSwift"]),        
    ]
)
