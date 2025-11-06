//
//  ProductCell.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//

import UIKit

final class ProductCell: UICollectionViewCell, CollectionViewCellInput {
    static let reuseID = "ProductCell"
    private let imageView = UIImageView()
    private let networkClient: NetworkClient = NetworkClientImpl()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        backgroundColor = .systemBackground
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with data: Any) {
        guard let data = data as? ProductCellData else { return }
        imageView.loadImage(at: data.imageUrls[0])
        
    }
    
    private func configureUI() {
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}
