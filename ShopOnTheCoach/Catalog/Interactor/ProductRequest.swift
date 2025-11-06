//
//  ProductRequest.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 04.11.2025.
//

import Foundation

class ProductRequest: NetworkRequest {
    typealias Response = [Product]
        
    var host = "https://api.escuelajs.co/api/v1"
    var path = "products"
    var httpMethod: HttpMethod = .GET
    var responseConverter = NetworkResponseConverterOf<Response>(converter: DecodingNetworkResponseConverter())
}
