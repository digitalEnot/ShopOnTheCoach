//
//  CatalogInteractor.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import Foundation

protocol CatalogInteractorInput {
    var output: CatalogInteractorOutput? { get set }
}

protocol CatalogInteractorOutput: AnyObject {
    
}

class CatalogInteractor: CatalogInteractorInput {
    weak var output: CatalogInteractorOutput?
}
