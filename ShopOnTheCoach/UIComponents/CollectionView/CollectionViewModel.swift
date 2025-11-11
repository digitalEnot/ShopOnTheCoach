//
//  CollectionViewModel.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//


import UIKit

typealias CollectionViewCell = UICollectionViewCell & CollectionViewCellInput

// TODO: убрать @unchecked
struct CollectionViewModel: Equatable, Hashable, @unchecked Sendable {
    
    let id: String
    let data: AnyHashable
    let cellType: CollectionViewCell.Type
    
    static func == (lhs: CollectionViewModel, rhs: CollectionViewModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.data == rhs.data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(data)
        hasher.combine(ObjectIdentifier(cellType))
    }
}
