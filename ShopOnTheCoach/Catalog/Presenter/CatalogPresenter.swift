//
//  CatalogPresenter.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import Foundation

protocol CatalogPresenterInput {
    var output: CatalogPresenterOutput? { get set }
}

// вот этот протокол сейчас не обязателен, но он нужен для вызова меодов из другого presenter.
protocol CatalogPresenterOutput: AnyObject {
    
}

class CatalogPresenter: CatalogPresenterInput {
    weak var output: CatalogPresenterOutput?
    
    private let router: CatalogRouterInput
    private let interactor: CatalogInteractorInput
    private weak var view: CatalogViewInput?
    
    init(router: CatalogRouterInput, interactor: CatalogInteractorInput, view: CatalogViewInput) {
        self.router = router
        self.interactor = interactor
        self.view = view
    }
}

extension CatalogPresenter: CatalogViewOutput {
    
}

extension CatalogPresenter: CatalogInteractorOutput {
    
}
