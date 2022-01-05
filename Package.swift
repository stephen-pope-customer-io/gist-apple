// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Gist",
    platforms: [
        .iOS(.v10)
    ],
    products: [        
        .library(
            name: "Gist",
            targets: ["Gist"]),
    ],    
    targets: [        
        .target(
            name: "Gist",
            dependencies: [],
            path: "Gist")
    ]
)
