// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseREST",
	platforms: [
		.iOS(.v9), .macOS(.v10_11), .tvOS(.v9), .watchOS(.v3)
	],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
		.library(
			name: "FirebaseAuthREST",
			targets: [
				"FirebaseAuthREST"
			]
		),
        .library(
            name: "FirebaseDatabaseREST",
            targets: [
				"FirebaseDatabaseREST"
			]
		),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
		.package(url: "https://github.com/henrik-dmg/HPNetwork", from: "1.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
		.target(
			name: "TestFoundation"
		),
		.target(
			name: "FirebaseAuthREST",
			dependencies: [
				"HPNetwork",
			]
		),
		.testTarget(
			name: "FirebaseAuthRESTTests",
			dependencies: [
				"FirebaseAuthREST",
				"TestFoundation"
			]
		),
		.target(
            name: "FirebaseDatabaseREST",
            dependencies: [
				"HPNetwork",
				"FirebaseAuthREST"
			]
		),
        .testTarget(
            name: "FirebaseDatabaseRESTTests",
            dependencies: [
				"FirebaseDatabaseREST",
				"TestFoundation"
			]
		)
    ]
)
