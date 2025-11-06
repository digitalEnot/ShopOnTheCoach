//
//  CatalogInteractor.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import Foundation

protocol CatalogInteractorInput {
    var output: CatalogInteractorOutput? { get set }
    func fetchProducts() async throws -> [Product]
}

protocol CatalogInteractorOutput: AnyObject {
    
}

class CatalogInteractor: CatalogInteractorInput {
    weak var output: CatalogInteractorOutput?
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func fetchProducts() async throws -> [Product] {
        try await networkClient.sendRequest(request: ProductRequest())
    }
}
