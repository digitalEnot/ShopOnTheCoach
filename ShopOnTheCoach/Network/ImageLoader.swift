//
//  ImageLoader.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//

import Foundation

class ImageRequest: NetworkRequest {
    typealias Response = Data
        
    var host: String
    var path = ""
    var httpMethod: HttpMethod = .GET
    var responseConverter = NetworkResponseConverterOf<Response>(converter: DataToResponseConverter())
    var needToCache = true
    
    init(host: String) {
        self.host = host
    }
}

protocol ImageLoaderProtocol {
    func downloadImageData(from url: String) async throws -> Data
}

final class ImageLoader: ImageLoaderProtocol {
    static let shared = ImageLoader()
    private let networkClient = NetworkClientImpl()
    
    private init() {}
    
    func downloadImageData(from url: String) async throws -> Data {
        try await networkClient.sendRequest(request: ImageRequest(host: url))
    }
}
