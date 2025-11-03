//
//  CatalogRouter.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import UIKit

protocol CatalogRouterInput {
    var rootViewController: UIViewController? { get set }
}

class CatalogRouter: CatalogRouterInput {
   weak var rootViewController: UIViewController?
}
