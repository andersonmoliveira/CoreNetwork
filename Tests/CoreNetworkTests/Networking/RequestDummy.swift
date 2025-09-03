//
//  RequestDummy.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 03/09/25.
//

@testable import CoreNetwork

struct RequestDummy: Request {

    var host: String = "example.com"
    var scheme: String = "https"
    var version: String = "/v1"
    var path: String = "/test"
    var method: HTTPMethod = .get
    var headers: [String : String]? = nil
    var bodyParams: [String : Any?]? = nil
    var queryParams: [String : String]? = nil
}
