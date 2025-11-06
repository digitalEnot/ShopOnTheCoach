//
//  NetworkClient.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 04.11.2025.
//

import Foundation

protocol NetworkClient {
    func sendRequest<Request: NetworkRequest>(request: Request) async throws(NetworkError) -> Request.Response
}

final class NetworkClientImpl: NetworkClient {
    
    private let urlSession: URLSession = URLSession(configuration: .default)
    private let requestBuilder: RequestBuilder
    
    init(requestBuilder: RequestBuilder = RequestBuilderImpl()) {
        self.requestBuilder = requestBuilder
    }
    
    func sendRequest<Request: NetworkRequest>(request: Request) async throws(NetworkError) -> Request.Response {
        let urlRequest = try requestBuilder.build(request: request)
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            return try decodeResponse(from: data, converter: request.responseConverter)
        } catch {
            throw .cantBuildUrlFromRequest  // TODO: заменить ошибку
        }
    }
    
    private func decodeResponse<Converter: NetworkResponseConverter>(
        from data: Data, converter: Converter
    ) throws -> Converter.Response {
        if let response = converter.decodeResponse(from: data) {
            return response
        } else {
            throw URLError(.cannotDecodeRawData)
        }
    }
}
