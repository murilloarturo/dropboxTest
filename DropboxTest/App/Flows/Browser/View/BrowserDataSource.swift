//
//  BrowserDataSource.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

protocol BrowserDataSourceDelegate: HeaderViewDelegate {
    func didSelect(index: Int)
    func loadMore()
}

class BrowserDataSource: NSObject {
    weak var collectionView: UICollectionView? {
        didSet {
            setupCollectionView()
        }
    }
    var data: DirectorySection? {
        didSet {
            collectionView?.reloadData()
        }
    }
    weak var delegate: BrowserDataSourceDelegate?
    
    func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.registerNibForCell(with: FileCell.self)
        collectionView.registerNibForSuplementaryView(with: HeaderView.self, kind: UICollectionView.elementKindSectionHeader)
        collectionView.registerNibForSuplementaryView(with: FooterView.self, kind: UICollectionView.elementKindSectionFooter)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.prefetchDataSource = self
    }
}

extension BrowserDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        return data.entries.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: FileCell.self, forIndexPath: indexPath)
        cell.update(with: data?.entries[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let cell = collectionView.dequeueSuplementaryView(with: HeaderView.self, forIndexPath: indexPath, kind: kind)
            cell.delegate = delegate
            cell.update(with: data?.user)
            return cell
        } else {
            let cell = collectionView.dequeueSuplementaryView(with: FooterView.self, forIndexPath: indexPath, kind: kind)
            cell.update(with: data?.footer)
            return cell
        }
    }
}

extension BrowserDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width / 3 - 10, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard data?.user != nil else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard data?.footer != nil else { return .zero }
        return CGSize(width: collectionView.bounds.width, height: 70)
    }
}

extension BrowserDataSource: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard indexPaths.contains(where: isLoadingCell) else { return }
        delegate?.loadMore()
    }
    
    func isLoadingCell(at indexPath: IndexPath) -> Bool {
        guard let data = data else { return false }
        return indexPath.row >= data.entries.count - 4
    }
}
