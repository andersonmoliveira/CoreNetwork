// swift-tools-version: 6.1
// A 'swift-tools-version' declara a versão mínima do Swift necessária para compilar este pacote.

import PackageDescription

let package = Package(
    // O nome do seu pacote.
    name: "CoreNetwork",
    // As plataformas (e versões) suportadas por este pacote.
    platforms: [
        .iOS(.v13),
    ],
    // Os produtos que este pacote irá gerar. No seu caso, uma biblioteca.
    products: [
        .library(
            name: "CoreNetwork",
            targets: ["CoreNetwork"]
        ),
    ],
    // Dependências de outros pacotes.
    dependencies: [
        .package(url: "https://github.com/kean/Nuke.git", from: "9.0.0")
    ],
    // Os targets (alvos) do seu pacote, que podem ser módulos ou suites de teste.
    targets: [
        // O target principal da sua biblioteca de networking.
        .target(
            name: "CoreNetwork",
            dependencies: [
                "Nuke"
            ]
        ),
        // O target de teste para a sua biblioteca.
        .testTarget(
            name: "CoreNetworkTests",
            dependencies: [
                "CoreNetwork"
            ]
        ),
    ]
)
