//
//  CatalogAssembly.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import UIKit

class CatalogAssembly {
    static func assembleCatalogModule() -> UIViewController {
        let view = CatalogView()
        let router = CatalogRouter()
        let interactor = CatalogInteractor()
        let presenter = CatalogPresenter(router: router, interactor: interactor, view: view)
        
        interactor.output = presenter
        view.output = presenter
        router.rootViewController = view
        
        return view
    }
}
