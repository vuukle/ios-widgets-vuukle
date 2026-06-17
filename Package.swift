// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "VuukleWidget",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "VuukleWidget", targets: ["VuukleWidget"]),
    ],
    dependencies: [
        // Sentry for automatic crash + error telemetry. Off unless a DSN is
        // configured by the publisher (or via Info.plist for the SDK build).
        .package(url: "https://github.com/getsentry/sentry-cocoa.git", from: "8.36.0"),
    ],
    targets: [
        .target(
            name: "VuukleWidget",
            dependencies: [
                .product(name: "Sentry", package: "sentry-cocoa"),
            ],
            resources: [.copy("Resources/Assets.xcassets")]),
        .testTarget(
            name: "VuukleWidgetTests",
            dependencies: ["VuukleWidget"]),
    ]
)
