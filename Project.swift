import Foundation
import ProjectDescription

/// Single source of truth for the marketing version. Edit the `VERSION` file
/// (semantic, e.g. "0.1.0"); `tuist generate` propagates it to the build.
let appVersion: String = {
    let path = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("VERSION")
        .path
    let raw = (try? String(contentsOfFile: path, encoding: .utf8)) ?? "0.1.0"
    return raw.trimmingCharacters(in: .whitespacesAndNewlines)
}()

/// Build number — bumped by hand. Edit the `BUILD` file (e.g. "1234");
/// `tuist generate` propagates it to CURRENT_PROJECT_VERSION → CFBundleVersion.
let buildNumber: String = {
    let path = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .appendingPathComponent("BUILD")
        .path
    let raw = (try? String(contentsOfFile: path, encoding: .utf8)) ?? "1"
    return raw.trimmingCharacters(in: .whitespacesAndNewlines)
}()

let project = Project(
    name: "Airlyhub",
    organizationName: "airly",
    options: .options(
        defaultKnownRegions: ["en", "vi"],
        developmentRegion: "en"
    ),
    settings: .settings(
        base: [
            "DEVELOPMENT_TEAM": "43P5X3R33K",
            "MARKETING_VERSION": "\(appVersion)",
            "CURRENT_PROJECT_VERSION": "\(buildNumber)",
            "SWIFT_VERSION": "5.0",
            "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"],
            "PRODUCT_BUNDLE_IDENTIFIER": "$(APP_BUNDLE_ID)",
        ],
        configurations: [
            .debug(name: "Dev", xcconfig: "Tuist/Config/Dev.xcconfig"),
            .debug(name: "Staging", xcconfig: "Tuist/Config/Staging.xcconfig"),
            .release(name: "Prod", xcconfig: "Tuist/Config/Prod.xcconfig"),
        ]
    ),
    targets: [
        .target(
            name: "Airlyhub",
            destinations: .iOS,
            product: .app,
            bundleId: "airly.Airlyhub",
            deploymentTargets: .iOS("15.6"),
            infoPlist: .file(path: "Sources/App/Info.plist"),
            sources: [
                "Sources/**/*.swift",
            ],
            resources: [
                .glob(pattern: "Resources/**"),
            ],
            scripts: [
                .pre(
                    path: "Tuist/Scripts/swiftlint.sh",
                    name: "SwiftLint",
                    basedOnDependencyAnalysis: false
                ),
                .post(
                    path: "Tuist/Scripts/copy-google-service-info.sh",
                    name: "Copy GoogleService-Info.plist",
                    basedOnDependencyAnalysis: false
                ),
            ],
            dependencies: [
                .external(name: "RxSwift"),
                .external(name: "RxCocoa"),
                .external(name: "RxRelay"),
                .external(name: "SnapKit"),
                .external(name: "FirebaseAI"),
                .external(name: "FirebaseAnalytics"),
                .external(name: "FirebaseAppCheck"),
                .external(name: "FirebaseAppDistribution-Beta"),
                .external(name: "FirebaseAuth"),
                .external(name: "FirebaseAuthCombine-Community"),
                .external(name: "FirebaseCore"),
                .external(name: "FirebaseCrashlytics"),
                .external(name: "FirebaseDatabase"),
                .external(name: "FirebaseFirestore"),
                .external(name: "FirebaseFirestoreCombine-Community"),
                .external(name: "FirebaseFunctions"),
                .external(name: "FirebaseFunctionsCombine-Community"),
                .external(name: "FirebaseInAppMessaging-Beta"),
                .external(name: "FirebaseMLModelDownloader"),
                .external(name: "FirebaseMessaging"),
                .external(name: "FirebasePerformance"),
                .external(name: "FirebaseRemoteConfig"),
                .external(name: "FirebaseStorage"),
                .external(name: "FirebaseStorageCombine-Community"),
            ],
            settings: .settings(
                base: [
                    "DEVELOPMENT_TEAM": "43P5X3R33K",
                    "MARKETING_VERSION": "\(appVersion)",
                    "CURRENT_PROJECT_VERSION": "\(buildNumber)",
                    "SWIFT_VERSION": "5.0",
                    "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"],
                    "PRODUCT_BUNDLE_IDENTIFIER": "$(APP_BUNDLE_ID)",
                ],
                configurations: [
                    .debug(name: "Dev", settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconDev",
                        "APP_BUNDLE_ID": "airly.Airlyhub.dev",
                        "APP_NAME": "Airlyhub Dev",
                        "APP_ENV": "DEV",
                    ]),
                    .debug(name: "Staging", settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIconStg",
                        "APP_BUNDLE_ID": "airly.Airlyhub.stg",
                        "APP_NAME": "Airlyhub Stg",
                        "APP_ENV": "STG",
                    ]),
                    .release(name: "Prod", settings: [
                        "ASSETCATALOG_COMPILER_APPICON_NAME": "AppIcon",
                        "APP_BUNDLE_ID": "airly.Airlyhub",
                        "APP_NAME": "Airlyhub",
                        "APP_ENV": "PROD",
                    ]),
                ]
            ),
            additionalFiles: [
                .folderReference(path: "Sources/Core/Config/Firebase"),
            ]
        ),
        .target(
            name: "AirlyhubTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "airly.AirlyhubTests",
            deploymentTargets: .iOS("15.6"),
            infoPlist: .default,
            sources: ["Tests/Unit/**/*.swift"],
            dependencies: [
                .target(name: "Airlyhub"),
            ]
        ),
        .target(
            name: "AirlyhubUITests",
            destinations: .iOS,
            product: .uiTests,
            bundleId: "airly.AirlyhubUITests",
            deploymentTargets: .iOS("15.6"),
            infoPlist: .default,
            sources: ["Tests/UI/**/*.swift"],
            dependencies: [
                .target(name: "Airlyhub"),
            ]
        ),
    ],
    schemes: [
        .scheme(
            name: "Airlyhub-Dev",
            shared: true,
            buildAction: .buildAction(targets: ["Airlyhub"]),
            runAction: .runAction(configuration: "Dev"),
            archiveAction: .archiveAction(configuration: "Dev")
        ),
        .scheme(
            name: "Airlyhub-Staging",
            shared: true,
            buildAction: .buildAction(targets: ["Airlyhub"]),
            runAction: .runAction(configuration: "Staging"),
            archiveAction: .archiveAction(configuration: "Staging")
        ),
        .scheme(
            name: "Airlyhub",
            shared: true,
            buildAction: .buildAction(targets: ["Airlyhub"]),
            runAction: .runAction(configuration: "Prod"),
            archiveAction: .archiveAction(configuration: "Prod")
        ),
    ],
    additionalFiles: [
        "Project.swift",
        "README.md",
        "VERSION",
        "BUILD",
        ".gitignore",
        ".mise.toml",
        ".swiftlint.yml",
        .folderReference(path: "Rules"),
        .folderReference(path: "Playground"),
        .glob(pattern: "Tuist/**"),
    ]
)
