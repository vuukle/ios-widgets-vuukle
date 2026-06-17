// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "VuukleWidget",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "VuukleWidget", targets: ["VuukleWidget"]),
    ],
    targets: [
        .target(
            name: "VuukleWidget",
            dependencies: [],
            resources: [.copy("Resources/Assets.xcassets")]),
        .testTarget(
            name: "VuukleWidgetTests",
            dependencies: ["VuukleWidget"]),
    ]
)
