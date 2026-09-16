// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CommonUI",
    platforms: [.iOS(.v18)],
    products: [
        .library(name: "CommonUI", targets: ["CommonUI"]),
    ],
    dependencies: [
        .package(path: "../Toolbox"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "7.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.22.3"),
    ],
    targets: [
        .target(
            name: "CommonUI",
            dependencies: [
                "Toolbox",
                "SFSafeSymbols",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .testTarget(
            name: "CommonUITests",
            dependencies: ["CommonUI"]
        ),
    ]
)
