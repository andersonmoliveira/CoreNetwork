//
//  Networking.swift
//  
//
//  Created by Anderson Oliveira on 02/09/25.
//

import Foundation
import Alamofire

public final class Networking: NetworkingProtocol {
    private let session: Session
    
    public init(session: Session = .default) {
        self.session = session
    }
    
    public func request<T: Decodable>(_ request: URLRequestConvertible) async throws -> T {
        return try await withCheckedThrowingContinuation { continuation in
            session.request(request)
                .validate()
                .responseDecodable(of: T.self, decoder: JSONDecoder()) { response in
                    switch response.result {
                    case .success(let value):
                        continuation.resume(returning: value)
                    case .failure(let error):
                        continuation.resume(throwing: APIError(error))
                    }
                }
        }
    }
}
