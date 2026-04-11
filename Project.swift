import ProjectDescription

let project = Project(
    name: "Airlyhub",
    organizationName: "airly",
    options: .options(
        defaultKnownRegions: ["en", "vi"],
        developmentRegion: "en"
    ),
    targets: [
        .target(
            name: "Airlyhub",
            destinations: .iOS,
            product: .app,
            bundleId: "airly.Airlyhub",
            deploymentTargets: .iOS("15.6"),
            infoPlist: .file(path: "Airlyhub/Info.plist"),
            sources: [
                "Airlyhub/**/*.swift",
                "Core/**/*.swift",
                "Data/**/*.swift",
                "Domain/**/*.swift",
                "DesignSystems/**/*.swift",
                "Modules/**/*.swift",
                "Utilities/**/*.swift",
                "Resources/**/*.swift",
            ],
            resources: [
                .glob(pattern: "Resources/**", excluding: ["Resources/**/*.swift"]),
                .glob(pattern: "Localization/**"),
                "Airlyhub/GoogleService-Info.plist",
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
                    "MARKETING_VERSION": "1.0",
                    "CURRENT_PROJECT_VERSION": "1",
                    "SWIFT_VERSION": "5.0",
                    "OTHER_LDFLAGS": ["$(inherited)", "-ObjC"],
                ]
            )
        ),
        .target(
            name: "AirlyhubTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "airly.AirlyhubTests",
            deploymentTargets: .iOS("15.6"),
            infoPlist: .default,
            sources: ["AirlyhubTests/**/*.swift"],
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
            sources: ["AirlyhubUITests/**/*.swift"],
            dependencies: [
                .target(name: "Airlyhub"),
            ]
        ),
    ]
)
