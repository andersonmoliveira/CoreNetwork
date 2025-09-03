# 📦 CoreNetwork

Biblioteca modular para **Networking em Swift**, testável e reutilizável.
Ideal para projetos iOS que necessitam de chamadas de API consistentes, com suporte a **mock**, **injeção de dependência** e **resiliência a falhas**.

---

## 🚀 Instalação

### Swift Package Manager

No seu `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/andersonmoliveira/CoreNetwork.git", from: "1.0.0")
]
```

E depois adicione a dependência ao seu target:

```swift
.target(
    name: "SeuApp",
    dependencies: [
        .product(name: "CoreNetwork", package: "CoreNetwork")
    ]
)
```

No Xcode:
File > Add Packages > https://github.com/andersonmoliveira/CoreNetwork.git

🔹 Funcionalidades Principais
Requisições HTTP GET, POST, PUT e DELETE

Suporte a JSON e codificação/decodificação de modelos Swift (Codable)

Injeção de dependência para facilitar testes unitários

Mock de respostas para desenvolvimento e testes

Gerenciamento de erros e retry automático

🎨 Exemplo de Uso
🔹 1. Requisição GET

```swift
let network = NetworkService()

network.request(endpoint: "/movies/popular", method: .get) { (result: Result<[Movie], NetworkError>) in
    switch result {
    case .success(let movies):
        print("Filmes populares: \(movies)")
    case .failure(let error):
        print("Erro na requisição: \(error)")
    }
}
```

🔹 2. Requisição POST com JSON

```swift
let movie = MovieRequest(title: "Novo Filme", releaseDate: "01/01/2025")

network.request(endpoint: "/movies", method: .post, body: movie) { (result: Result<Movie, NetworkError>) in
    switch result {
    case .success(let createdMovie):
        print("Filme criado: \(createdMovie)")
    case .failure(let error):
        print("Erro ao criar filme: \(error)")
    }
}
```

🔹 3. Mock de Resposta

```swift
let mockNetwork = MockNetworkService()
mockNetwork.mockResponse(for: "/movies/popular", response: [Movie(title: "Filme Mock", releaseDate: "01/01/2025")])
```

🛠️ Roadmap

* [ ] Monitoramento de performance de requisições
* [ ] Suporte a autenticação OAuth2
* [ ] Cache de respostas

📄 Licença
Este projeto está sob a licença MIT. Consulte o arquivo LICENSE para mais detalhes.
