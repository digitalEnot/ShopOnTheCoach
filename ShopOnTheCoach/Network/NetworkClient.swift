//
//  NetworkClient.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 04.11.2025.
//

import Foundation

protocol NetworkClient {
    func sendRequest<Request: NetworkRequest>(request: Request) async throws(NetworkError) -> [Request.Responce]
}

final class NetworkClientImpl: NetworkClient {
    
    private let urlSession: URLSession = URLSession(configuration: .default)
    private let requestBuilder: RequestBuilder
    
    init(requestBuilder: RequestBuilder = RequestBuilderImpl()) {
        self.requestBuilder = requestBuilder
    }
    
    func sendRequest<Request: NetworkRequest>(request: Request) async throws(NetworkError) -> [Request.Responce] {
        let urlRequest = try requestBuilder.build(request: request)
        
        do {
            let (data, _) = try await urlSession.data(for: urlRequest)
            let responce = try JSONDecoder().decode([Request.Responce].self, from: data)
            return responce
        } catch {
            throw .cantBuildUrlFromRequest  // TODO: заменить ошибку
        }
    }
}
