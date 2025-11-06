//
//  CollectionViewModel.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//


import UIKit

typealias CollectionViewCell = UICollectionViewCell & CollectionViewCellInput

struct CollectionViewModel: Equatable {
    
    // MARK: - Properties
    let id: String
    let data: AnyHashable
    let cellType: CollectionViewCell.Type
    
    // MARK: - Equatable
    static func == (lhs: CollectionViewModel, rhs: CollectionViewModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.data == rhs.data
    }
}
