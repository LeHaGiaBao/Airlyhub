// swift-tools-version: 5.9
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "RxSwift": .framework,
        "RxCocoa": .framework,
        "RxRelay": .framework,
        "SnapKit": .framework,
    ]
)
#endif

let package = Package(
    name: "Airlyhub",
    dependencies: [
        .package(
            url: "https://github.com/ReactiveX/RxSwift",
            from: "6.9.1"
        ),
        .package(
            url: "https://github.com/SnapKit/SnapKit.git",
            from: "5.7.1"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "12.11.0"
        ),
    ]
)
