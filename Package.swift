// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "PackageRegistry",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0"),
        .package(url: "https://github.com/SwiftDocOrg/Git.git", branch: "main"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMinor(from: "0.9.0")),
        .package(url: "https://github.com/apple/swift-argument-parser.git", .upToNextMinor(from: "0.3.1")),
        .package(url: "https://github.com/apple/swift-log.git", .upToNextMinor(from: "1.4.0")),
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .upToNextMinor(from: "0.3.0"))
    ],
    targets: [
        .target(
            name: "PackageRegistry",
            dependencies: [
                .product(name: "Git", package: "Git"),
                .product(name: "ZIPFoundation", package: "ZIPFoundation"),
                .product(name: "AnyCodable", package: "AnyCodable")
            ]),
        .executableTarget(
            name: "registry",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "AnyCodable", package: "AnyCodable"),
                .product(name: "Logging", package: "swift-log"),
                .target(name: "PackageRegistry"),
                .target(name: "Server")
            ],
            path: "Sources/CLI"),
        .target(
            name: "Server",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "AnyCodable", package: "AnyCodable"),
                .target(name: "PackageRegistry")
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .testTarget(name: "ServerTests", dependencies: [
            .target(name: "Server"),
            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "ZIPFoundation", package: "ZIPFoundation"),
        ]),
        .testTarget(name: "PackageRegistryTests", dependencies: [
            .target(name: "PackageRegistry"),
            .product(name: "AnyCodable", package: "AnyCodable")
        ])
    ]
)
