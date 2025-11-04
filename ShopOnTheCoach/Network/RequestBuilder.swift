//
//  RequestBuilder.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 04.11.2025.
//

import Foundation

protocol RequestBuilder: AnyObject {
    func build(request: any NetworkRequest) throws(NetworkError) -> URLRequest
}

final class RequestBuilderImpl: RequestBuilder {
    
    // MARK: - RequestBuilder
    func build(request: any NetworkRequest) throws(NetworkError) -> URLRequest {
        guard let url = URL(string: "https://\(request.host)/\(request.path)") else {
            throw .cantBuildUrlFromRequest // TODO: заменить ошибку
        }
        
        var urlRequest = URLRequest(url: url, timeoutInterval: 15)
        urlRequest.httpMethod = request.httpMethod.rawValue
        
        return urlRequest
    }
}
