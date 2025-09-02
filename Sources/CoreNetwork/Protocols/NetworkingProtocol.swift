//
//  NetworkingProtocol.swift
//  
//
//  Created by Anderson Oliveira on 02/09/25.
//

import Alamofire

public protocol NetworkingProtocol {
    func request<T: Decodable>(_ request: URLRequestConvertible) async throws -> T
}
