//
//  Networking.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 02/09/25.
//

import Foundation

public final class Networking: NetworkingProtocol {

    private let session: URLSession
    private static let sharedImageCache: URLCache = {
            let memoryCapacity = 50 * 1024 * 1024
            let diskCapacity = 50 * 1024 * 1024
            return URLCache(memoryCapacity: memoryCapacity,
                            diskCapacity: diskCapacity,
                            diskPath: "CoreNetwork.Networking.sharedImageCache")
        }()
    
    public init(session: URLSession = .shared) {
        self.session = session
    }

    public init(configuration: URLSessionConfiguration? = nil) {
        let config: URLSessionConfiguration
        if let configuration {
            config = configuration
        } else {
            config = URLSessionConfiguration.default
        }
        config.urlCache = Networking.sharedImageCache
        config.requestCachePolicy = .returnCacheDataElseLoad
        self.session = URLSession(configuration: config)
    }
    
    public func request<T: Decodable>(_ request: Request) async throws -> T {
        let urlRquest = try urlRequest(from: request)

        return try await withCheckedThrowingContinuation { continuation in
            session.dataTask(with: urlRquest) { (data, response, error) in
                if let error {
                    continuation.resume(throwing: APIError.network(error))
                    return
                }
                
                guard let data, !data.isEmpty else {
                    continuation.resume(throwing: APIError.noData)
                    return
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    continuation.resume(returning: decoded)
                } catch {
                    continuation.resume(throwing: APIError.decoding)
                }
            }.resume()
        }
    }

    public func request(_ request: Request) async throws -> Data {
        var request = try urlRequest(from: request)
        request.cachePolicy = .returnCacheDataElseLoad
        
        do {
            let (data, _) = try await session.data(for: request)
            return data
        } catch let error {
            throw APIError.network(error)
        }
    }

    private func urlRequest(from request: Request) throws -> URLRequest {
        var components = URLComponents()
        components.scheme = request.scheme
        components.host = request.host
        components.path = "\(request.version)\(request.path)"
        
        if let queryParams = request.queryParams {
            components.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        
        if let headers = request.headers {
            for (key, value) in headers {
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        if let bodyParams = request.bodyParams {
            urlRequest.httpBody = try JSONSerialization.data(
                withJSONObject: bodyParams.compactMapValues { $0 },
                options: []
            )
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return urlRequest
    }
}
