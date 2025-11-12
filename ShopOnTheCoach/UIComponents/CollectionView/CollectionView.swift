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
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    var dataSourse: UICollectionViewDiffableDataSource<Section, CollectionViewModel>?
    var loadingView: LoadingFooterView?
    
    var onLoadMore: ((Int) async -> [CollectionViewModel])?
    var isLoading = false
    
    private var models: [CollectionViewModel] = []
    private var registerCells: Set<String> = []
    
    init() {
        super.init(frame: .zero)
        setUpContent()
        configureDataSourse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }
    
    private func configureDataSourse() {
        dataSourse = UICollectionViewDiffableDataSource<Section, CollectionViewModel>(collectionView: collectionView) {
            collectionView, indexPath, model in
            let cell = self.cell(indexPath: indexPath, model: model)
            if let cell = cell as? CollectionViewCell {
                cell.update(with: model.data)
            }
            return cell
        }
        
        dataSourse?.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
            guard let self = self else { return nil }
            
            if kind == UICollectionView.elementKindSectionFooter {
                let footer = collectionView.dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: LoadingFooterView.reuseId,
                    for: indexPath
                ) as! LoadingFooterView
                
                self.loadingView = footer
                return footer
            }
            return nil
        }
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
    
    private func setUpContent() {
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = Spec.backgroundColor
        collectionView.register(LoadingFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: LoadingFooterView.reuseId)
    }
    
    private func scrolledToEnd() {
        isLoading = true
        collectionView.collectionViewLayout.invalidateLayout()
        guard let onLoadMore else { isLoading = false; return }
        Task {
            let newModels = await onLoadMore(models.count)
            models.append(contentsOf: newModels)
            isLoading = false
            updateData(on: models)
        }
    }
    
    private func updateData(on models: [CollectionViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CollectionViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(models)
        DispatchQueue.main.async { [weak self] in
            self?.dataSourse?.apply(snapshot, animatingDifferences: true)
        }
    }
    
    func display(models: [CollectionViewModel]) {
        guard self.models != models else { return }
        
        self.models = models
        updateData(on: models)
    }
    
    func setCollectionViewLayout(_ layout: UICollectionViewLayout) {
        collectionView.setCollectionViewLayout(layout, animated: false)
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
}

extension CollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if !self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 65)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.startAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.stopAnimating()
        }
    }
}

fileprivate enum Spec {
    static let backgroundColor = UIColor.systemBackground
}
