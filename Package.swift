// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//@f:0
let package = Package(
    name: "Pullman",
    platforms: [ .macOS(.v11), .tvOS(.v14), .iOS(.v14), .watchOS(.v7) ],
    products: [
        .library(name: "Pullman", targets: [ "Pullman" ]),
    ],
    dependencies: [
        .package(name: "Rubicon", url: "https://github.com/GalenRhodes/Rubicon.git", .upToNextMinor(from: "0.9.0")),
        .package(name: "RedBlackTree", url: "https://github.com/GalenRhodes/RedBlackTree.git", .upToNextMajor(from: "2.0.5"))
    ],
    targets: [
        .target(name: "Pullman", dependencies: [ "Rubicon", "RedBlackTree" ], exclude: [ "Info.plist", ]),
        .testTarget(name: "PullmanTests", dependencies: [ "Pullman" ], exclude: [ "Info.plist", ]),
    ])
//@f:1
