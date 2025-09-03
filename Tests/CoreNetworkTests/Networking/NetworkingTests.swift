//
//  NetworkingTests.swift
//  CoreNetwork
//
//  Created by Anderson Oliveira on 03/09/25.
//

import XCTest
@testable import CoreNetwork

final class NetworkingTests: XCTestCase {

    struct MockResponse: Codable, Equatable { let message: String }
    var sut: Networking!
    private var requestDummy = RequestDummy()

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: config)
        sut = Networking(session: session)
    }

    override func tearDown() {
        super.tearDown()
        sut = nil
        URLProtocolStub.requestHandler = nil
    }

    // MARK: - Helpers

    private func setupMockResponse(data: Data?, statusCode: Int = 200) {
        URLProtocolStub.requestHandler = {
            let response = HTTPURLResponse(
                url: URL(string: "https://example.com/v1/test")!,
                statusCode: statusCode,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, data)
        }
    }

    private func setupMockError(_ error: Error) {
        URLProtocolStub.requestHandler = { throw error }
    }

    // MARK: - Testes

    func testRequest_Success() async throws {
        // Given
        struct MockResponse: Codable, Equatable { let message: String }
        let expected = MockResponse(message: "Hello")
        let data = try JSONEncoder().encode(expected)
        setupMockResponse(data: data)
        
        // When
        let result: MockResponse = try await sut.request(requestDummy)
        
        // Then
        XCTAssertEqual(result, expected)
    }
    
    func testRequest_EmptyResponse() async throws {
        // Given
        let expected = EmptyResponse()
        let data = try JSONEncoder().encode(expected)
        setupMockResponse(data: data, statusCode: 204)
        
        // When
        let result: EmptyResponse = try await sut.request(requestDummy)
        
        // Then
        XCTAssertEqual(result, expected)
    }

    func testRequest_NetworkError() async {
        // Given
        let errorDummy = NSError(domain: "Network", code: 123, userInfo: nil)
        setupMockError(errorDummy)
        
        // When / Then
        do {
            let _: String = try await sut.request(requestDummy)
            XCTFail("Deveria falhar com network error")
        } catch let error {
            XCTAssertEqual(error as! APIError, APIError.network(errorDummy))
        }
    }

    func testRequest_NoDataError() async {
        // Given
        setupMockResponse(data: nil)
        
        // When / Then
        do {
            let _: String = try await sut.request(requestDummy)
            XCTFail("Deveria falhar com noData")
        } catch let error {
            XCTAssertEqual(error as! APIError, APIError.noData)
        }
    }
    
    func testRequest_DecodingError() async {
        // Given
        struct MockResponse: Codable, Equatable { let message: String }
        let invalidData = "invalid json".data(using: .utf8)!
        setupMockResponse(data: invalidData)
        
        // When / Then
        do {
            let _: MockResponse = try await sut.request(requestDummy)
            XCTFail("Deveria falhar com decoding error")
        } catch let error {
            XCTAssertEqual(error as! APIError, APIError.decoding)
        }
    }

    func testRequest_InvalidURL() async {
        // Given
        requestDummy.host = "@"
        setupMockResponse(data: nil)
        
        // When / Then
        do {
            let _: MockResponse = try await sut.request(requestDummy)
            XCTFail("Deveria falhar com decoding error")
        } catch let error {
            XCTAssertEqual(error as! APIError, APIError.invalidURL)
        }
    }

    func testRequestData_Success() async throws {
        // Given
        let expectedData = "Hello World".data(using: .utf8)!
        setupMockResponse(data: expectedData)
        
        // When
        let data = try await sut.request(requestDummy)
        
        // Then
        XCTAssertEqual(data, expectedData)
    }

    func testRequestData_NetworkError() async {
        // Given
        let errorDummy = NSError(domain: "Network", code: 123, userInfo: nil)
        setupMockError(errorDummy)
        
        // When / Then
        do {
            let _: Data = try await sut.request(requestDummy)
            XCTFail("Request deveria falhar com network error")
        } catch let error {
            XCTAssertEqual(error as! APIError, APIError.network(errorDummy))
        }
    }
}
