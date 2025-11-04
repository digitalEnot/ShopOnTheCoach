//
//  ProductRequest.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 04.11.2025.
//

import Foundation

class ProductRequest: NetworkRequest { // TODO: переместить в presenter
    typealias Responce = Product
        
    var host = "api.escuelajs.co/api/v1"
    var path = "products"
    var httpMethod: HttpMethod = .GET
}
