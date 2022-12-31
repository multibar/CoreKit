// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreKit",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "CoreKit",
            targets: ["CoreKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-collections.git",
            from: "1.0.4"
        ),
        .package(
            url: "https://github.com/kishikawakatsumi/KeychainAccess",
            from: "4.2.2"
        )
    ],
    targets: [
        .target(
            name: "CoreKit",
            dependencies: [
                .product(name: "Collections", package: "swift-collections"),
                .product(name: "KeychainAccess", package: "KeychainAccess")
            ]
        ),
        .testTarget(
            name: "CoreKitTests",
            dependencies: ["CoreKit"]),
    ]
)
