//
//  CollectionView.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//

import UIKit

class CollectionView: UIView {
    
    private var models: [CollectionViewModel] = []
    private var registerCells: Set<String> = []
    var onLoadMore: ((Int) async -> [CollectionViewModel])?
    var isLoading = false
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        setUpContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContent() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = Spec.backgroundColor
    }
    
    func display(models: [CollectionViewModel]) {
        guard self.models != models else { return }
        
        self.models = models
        collectionView.reloadData()
    }
    
    func setCollectionViewLayout(_ layout: UICollectionViewLayout) {
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
}

extension CollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        models.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.item]
        let cell = cell(indexPath: indexPath, model: model)

        if let cell = cell as? CollectionViewCellInput {
            cell.update(with: model.data)
        }
        
        return cell
    }
    
    private func cell(indexPath: IndexPath, model: CollectionViewModel) -> UICollectionViewCell {
        if !registerCells.contains(model.id) {
            registerCells.insert(model.id)
            collectionView.register(
                model.cellType,
                forCellWithReuseIdentifier: model.id
            )
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: model.id, for: indexPath)
    }
}

extension CollectionView: UICollectionViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > (contentHeight - height) {
            if !isLoading {
                scrolledToEnd()
            }
        }
    }
    
    private func scrolledToEnd() {
        isLoading = true
        guard let onLoadMore else { isLoading = false; return }
        Task {
            let oldCount = models.count
            models.append(contentsOf: await onLoadMore(oldCount))
            let newIndexPaths = (oldCount..<models.count).map { IndexPath(item: $0, section: 0) }
            collectionView.insertItems(at: newIndexPaths)
            isLoading = false
        }
    }
}

// MARK: - Spec
fileprivate enum Spec {
    static let backgroundColor = UIColor.systemBackground
}
