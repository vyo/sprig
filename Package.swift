import PackageDescription

let package = Package(  
    name: "Sprig",
    targets: []
    dependencies: [
        .Package(url: "https://github.com/Thomvis/BrightFutures",
            majorVersion: 3)
    ]
)
