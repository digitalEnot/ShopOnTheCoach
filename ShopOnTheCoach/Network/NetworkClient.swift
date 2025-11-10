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
    private let cache: NSCache<NSString, NSData>
    
    init(requestBuilder: RequestBuilder = RequestBuilderImpl(), cache: NSCache<NSString, NSData> = .init()) {
        self.requestBuilder = requestBuilder
        self.cache = cache
    }
    
    func sendRequest<Request: NetworkRequest>(request: Request) async throws(NetworkError) -> Request.Response {
        let urlRequest = try requestBuilder.build(request: request)
        
        do {
            if let cachedData = cachedData(urlString: urlRequest.url?.absoluteString) {
                return try decodeResponse(from: cachedData, converter: request.responseConverter)
            }
            
            let (data, _) = try await urlSession.data(for: urlRequest)
            if request.needToCache {
                cacheDataIfNeeded(urlString: urlRequest.url?.absoluteString, data: data)
            }
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
    
    private func cacheDataIfNeeded(urlString: String?, data: Data) {
        guard let urlString else { return }
        cache.setObject(data as NSData, forKey: urlString as NSString)
    }
    
    private func cachedData(urlString: String?) -> Data? {
        guard let urlString else { return nil }
        return cache.object(forKey: urlString as NSString) as? Data
    }
}
