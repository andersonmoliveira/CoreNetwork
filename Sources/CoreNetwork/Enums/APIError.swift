//
//  File.swift
//  
//
//  Created by Anderson Oliveira on 02/09/25.
//

import Foundation
import Alamofire

public enum APIError: Error {
    case network(AFError)
    case decoding(Error)
    case unknown(Error)
    
    init(_ error: Error) {
        if let afError = error as? AFError {
            self = .network(afError)
        } else if error is DecodingError {
            self = .decoding(error)
        } else {
            self = .unknown(error)
        }
    }
}
