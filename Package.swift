// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "RSSelectionMenu",
    platforms: [
        .iOS(.v12),
    ],
    products: [
        .library(name: "RSSelectionMenu", targets: ["RSSelectionMenu"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "RSSelectionMenu",
            dependencies: [
            ],
            path: "RSSelectionMenu"
        )
    ],
    swiftLanguageVersions: [ .v5 ]
)

