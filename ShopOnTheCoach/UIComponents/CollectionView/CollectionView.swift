//
//  CollectionView.swift
//  ShopOnTheCoach
//
//  Created by Evgeni Novik on 06.11.2025.
//

import UIKit

class CollectionView: UIView {
    
    enum Section {
        case main
    }
    
    private var models: [CollectionViewModel] = []
    private var registerCells: Set<String> = []
    var onLoadMore: ((Int) async -> [CollectionViewModel])?
    var isLoading = false
    var dataSourse: UICollectionViewDiffableDataSource<Section, CollectionViewModel>?
    
    private func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, CollectionViewModel>(collectionView: collectionView, cellProvider: { collectionView, indexPath, model in
            let cell = self.cell(indexPath: indexPath, model: model)
            if let cell = cell as? CollectionViewCell {
                cell.update(with: model.data)
            }
            return cell
        })
    }
    
    private func cell(indexPath: IndexPath, model: CollectionViewModel) -> UICollectionViewCell {
        if !registerCells.contains(model.typeName) {
            registerCells.insert(model.typeName)
            collectionView.register(
                model.cellType,
                forCellWithReuseIdentifier: model.typeName
            )
        }
        return collectionView.dequeueReusableCell(withReuseIdentifier: model.typeName, for: indexPath)
    }
    
    func updateData(on models: [CollectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CollectionViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        DispatchQueue.main.async { [weak self] in
            self?.dataSourse?.apply(snapshot, animatingDifferences: true)
            self?.isLoading = false
        }
    }
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    init() {
        super.init(frame: .zero)
        
        addSubview(collectionView)
        setUpContent()
        configureDataSourse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpContent() {
        collectionView.delegate = self
        collectionView.backgroundColor = Spec.backgroundColor
    }
    
    func display(models: [CollectionViewModel]) {
        guard self.models != models else { return }
        
        self.models = models
        updateData(on: models)
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
            let newModels = await onLoadMore(models.count)
            models.append(contentsOf: newModels)
            updateData(on: models)
        }
    }
}

// MARK: - Spec
fileprivate enum Spec {
    static let backgroundColor = UIColor.systemBackground
}
