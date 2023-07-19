// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Features",
    defaultLocalization: "de",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "MainFeature", targets: ["MainFeature"]),
        .library(name: "AuthFeature", targets: ["AuthFeature"]),
        .library(name: "ExampleFeature", targets: ["ExampleFeature"]),
        .library(name: "DebugFeature", targets: ["DebugFeature"]),
    ],
    dependencies: [
        .package(url: "https://github.com/allaboutapps/StatefulViewController.git", from: "5.2.0"),
        .package(url: "https://github.com/Alamofire/AlamofireImage.git", from: "4.2.0"),
        .package(url: "https://github.com/allaboutapps/DataSource.git", from: "8.1.3"),
        .package(path: "../Core"),
    ],
    targets: [
        .target(
            name: "MainFeature",
            dependencies: [
                "ExampleFeature",
                .product(name: "Assets", package: "Core"),
                .product(name: "CommonUI", package: "Core"),
                .product(name: "Models", package: "Core"),
                .product(name: "Networking", package: "Core"),
                .product(name: "Utilities", package: "Core"),
            ]
        ),
        .target(
            name: "AuthFeature",
            dependencies: [
                "StatefulViewController",
                "AlamofireImage",
                "DataSource",
                .product(name: "Assets", package: "Core"),
                .product(name: "CommonUI", package: "Core"),
                .product(name: "Models", package: "Core"),
                .product(name: "Networking", package: "Core"),
                .product(name: "Utilities", package: "Core"),
            ]
        ),
        .target(
            name: "ExampleFeature",
            dependencies: [
                "StatefulViewController",
                "AlamofireImage",
                "DataSource",
                .product(name: "Assets", package: "Core"),
                .product(name: "CommonUI", package: "Core"),
                .product(name: "Models", package: "Core"),
                .product(name: "Networking", package: "Core"),
                .product(name: "Utilities", package: "Core"),
                "DebugFeature",
            ]
        ),
        .target(
            name: "DebugFeature",
            dependencies: [
                .product(name: "Assets", package: "Core"),
                .product(name: "CommonUI", package: "Core"),
                .product(name: "Models", package: "Core"),
                .product(name: "Utilities", package: "Core"),
            ]
        ),
    ]
)
