//
//  ImageDataDownloader.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 02/09/25.
//

public protocol Request {

    var host: String { get }
    var scheme: String { get }
    var version: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var bodyParams: [String: Any?]? { get }
    var queryParams: [String: String]? { get }
}
