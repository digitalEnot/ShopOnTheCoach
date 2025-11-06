//
//  DecodingNetworkResponseConverter.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//
import Foundation

protocol NetworkResponseConverter: AnyObject {
    associatedtype Response
    
    func decodeResponse(from data: Data) -> Response?
}

final class DecodingNetworkResponseConverter<Response>: NetworkResponseConverter where Response: Decodable {
    
    func decodeResponse(from data: Data) -> Response? {
        try? JSONDecoder().decode(Response.self, from: data)
    }
}

final class DataToResponseConverter<Response>: NetworkResponseConverter where Response: Decodable {
    
    func decodeResponse(from data: Data) -> Response? {
        data as? Response
    }
}
