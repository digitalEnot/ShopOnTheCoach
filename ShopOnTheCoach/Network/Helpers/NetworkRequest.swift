//
//  NetworkRequest.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 04.11.2025.
//

import Foundation

protocol NetworkRequest {
    associatedtype Response: Decodable
    
    var host: String { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var responseConverter: NetworkResponseConverterOf<Response> { get }
    var needToCache: Bool { get }
}
