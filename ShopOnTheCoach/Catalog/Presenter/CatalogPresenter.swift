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

// вот этот протокол сейчас необязателен, но он нужен для вызова меодов из другого presenter.
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
        setupView()
    }
    
    private func setupView() {
        view?.onLoadMore = { [weak self] offset in
            guard let self else { return [] }
            guard let products = try? await self.interactor.fetchProducts(offset: offset) else { return [] }
            return products
                .map {
                    CollectionViewModel(
                        id: ProductCell.reuseID,
                        data: ProductCellData(imageUrls: $0.images, title: $0.title),
                        cellType: ProductCell.self
                    )
                }
        }
    }
    
    private func fetchProducts() {
        Task {
            do {
                let products = try await interactor.fetchProducts(offset: 0)
                
                view?.display(products: products
                    .map {
                        CollectionViewModel(
                            id: ProductCell.reuseID,
                            data: ProductCellData(imageUrls: $0.images, title: $0.title),
                            cellType: ProductCell.self
                        )
                    }
                )
            }
            catch {
                print("error") // TODO: заменить
            }
        }
    }
}

extension CatalogPresenter: CatalogViewOutput {
    func viewDidLoad() {
        fetchProducts()
    }
}

extension CatalogPresenter: CatalogInteractorOutput {
    
}
