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
            url: "https://github.com/nnabeyang/zxing-cpp/releases/download/ios-v0.0.2/ZXing.xcframework.zip",
            checksum: "ae6ce97c6ad85dcd2afad2ba034db09090bd4dcacf94807b12d1624ae722acf5"),
        .testTarget(
            name: "ZXingSwiftTests",
            dependencies: ["ZXingSwift"]),        
    ]
)
