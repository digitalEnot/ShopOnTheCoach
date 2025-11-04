//
//  CatalogView.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import UIKit

protocol CatalogViewInput: AnyObject {
    var output: CatalogViewOutput? { get set }
}

protocol CatalogViewOutput {

}

class CatalogView: UIViewController, CatalogViewInput {
    
    var output: CatalogViewOutput?

    override func viewDidLoad() {
        super.viewDidLoad()
        Task {
            let ans = try? await NetworkClientImpl().sendRequest(request: ProductRequest())
            print(ans)
        }
    }
}
