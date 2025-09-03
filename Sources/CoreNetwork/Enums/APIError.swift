//
//  APIError.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 02/09/25.
//

import Foundation

public enum APIError: Error, Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.network(let lhs), .network(let rhs)):
            return lhs.localizedDescription == rhs.localizedDescription
        case (.decoding, .decoding):
            return true
        case (.noData, .noData):
            return true
        case (.invalidURL, .invalidURL):
            return true
        default: return false
        }
    }
    

    case network(Error)
    case decoding
    case noData
    case invalidURL
}
