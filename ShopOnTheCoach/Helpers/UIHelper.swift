//
//  UIHelper.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//

import UIKit

struct UIHelper {
    static func createTwoSquareColumnLayout(in view:  UIView) -> UICollectionViewFlowLayout {
        let width = view.bounds.width
        let availableWidth = width - 4
        let itemWidth = availableWidth / 2
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumLineSpacing = 2
        flowLayout.minimumInteritemSpacing = 2
        
        return flowLayout
    }
}
