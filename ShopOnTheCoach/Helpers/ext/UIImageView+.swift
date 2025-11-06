//
//  UIImageView+.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//

import UIKit
extension UIImageView {
    func loadImage(at url: String) {
        Task {
            let data = try await ImageLoader.shared.downloadImageData(from: url)
            self.image = UIImage(data: data)
        }
    }
}
