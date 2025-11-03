//
//  CatalogEntity.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 03.11.2025.
//

import Foundation

struct Product: Codable {
    let id: Int
    let title, slug: String
    let price: Int
    let description: String
    let category: Category
    let images: [String]
}

struct Category: Codable {
    let id: Int
    let name: String
    let image: String
    let slug: String
}
