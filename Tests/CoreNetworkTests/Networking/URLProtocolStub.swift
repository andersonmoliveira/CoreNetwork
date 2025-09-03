//
//  URLProtocolStub.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 03/09/25.
//

import Foundation

final class URLProtocolStub: URLProtocol {
    nonisolated(unsafe) static var requestHandler: (() throws -> (HTTPURLResponse, Data?))?

    override class func canInit(with request: URLRequest) -> Bool { true }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let handler = URLProtocolStub.requestHandler else {
            fatalError("Handler não configurado.")
        }
        do {
            let (response, data) = try handler()
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
