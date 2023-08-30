// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "Core",
    defaultLocalization: "de",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Assets", targets: ["Assets"]),
        .library(name: "CommonUI", targets: ["CommonUI"]),
        .library(name: "Models", targets: ["Models"]),
        .library(name: "Networking", targets: ["Networking"]),
        .library(name: "Utilities", targets: ["Utilities"]),
    ],
    dependencies: [
        .package(url: "https://github.com/allaboutapps/Fetch.git", from: "3.0.0"),
        .package(url: "https://github.com/allaboutapps/Logbook.git", from: "1.1.0"),
        .package(url: "https://github.com/allaboutapps/Toolbox.git", from: "5.0.0"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
    ],
    targets: [
        .target(
            name: "Assets",
            dependencies: ["Logbook", "Toolbox", "KeychainAccess"]
        ),
        .target(
            name: "CommonUI",
            dependencies: ["Assets", "Models", "Utilities", "Logbook", "Toolbox", "AlamofireImage"]
        ),
        .target(
            name: "Models",
            dependencies: ["Logbook", "Toolbox", "KeychainAccess"]
        ),
        .target(
            name: "Networking",
            dependencies: ["Models", "Utilities", "Fetch", "Logbook", "Toolbox", "KeychainAccess"],
            resources: [
                .process("Stubs"),
            ]
        ),
        .target(
            name: "Utilities",
            dependencies: ["Fetch", "Logbook", "Toolbox", "KeychainAccess"]
        ),
    ]
)
