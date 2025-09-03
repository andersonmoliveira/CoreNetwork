//
//  NetworkingProtocol.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 02/09/25.
//

import Foundation

public protocol NetworkingProtocol {

    func request<T: Decodable>(_ request: Request) async throws -> T
    func request(_ request: Request) async throws -> Data
}
