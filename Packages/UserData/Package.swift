// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "UserData",
    platforms: [.macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "UserData",
            targets: ["UserData"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(path: "../DevToolsCore"),
        .package(path: "../FirebaseClient"),
        .package(url: "https://github.com/marmelroy/Zip.git", exact: "2.1.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "UserData",
            dependencies: [
                .byName(name: "DevToolsCore"),
                .byName(name: "FirebaseClient"),
                .byName(name: "Zip"),
            ]),
        .testTarget(
            name: "UserDataTests",
            dependencies: ["UserData"]),
    ]
)
