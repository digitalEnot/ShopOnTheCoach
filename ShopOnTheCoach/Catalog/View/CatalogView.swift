//
//  CatalogView.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import UIKit

protocol CatalogViewInput: AnyObject {
    var output: CatalogViewOutput? { get set }
    var onLoadMore: ((Int) async -> [CollectionViewModel])? { get set }
    func display(products: [CollectionViewModel])
}

protocol CatalogViewOutput {
    func viewDidLoad()
}

class CatalogView: UIViewController, CatalogViewInput {
    
    var output: CatalogViewOutput?
    let collectionView = CollectionView()
    
    var onLoadMore: ((Int) async -> [CollectionViewModel])? {
        get { collectionView.onLoadMore }
        set { collectionView.onLoadMore = newValue }
    }
        
    func display(products: [CollectionViewModel]) {
        collectionView.display(models: products)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        output?.viewDidLoad()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.setCollectionViewLayout(UIHelper.createTwoSquareColumnLayout(in: self.view))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
    }
}
