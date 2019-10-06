//
//  BrowserDataSource.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

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
    
    func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.registerNibForCell(with: FileCell.self)
        collectionView.registerNibForSuplementaryView(with: HeaderView.self, kind: UICollectionView.elementKindSectionHeader)
        
        collectionView.dataSource = self
        collectionView.delegate = self
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
        let cell = collectionView.dequeueSuplementaryView(with: HeaderView.self, forIndexPath: indexPath, kind: kind)
        cell.update(with: data?.user)
        return cell
    }
}

extension BrowserDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.5, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let height: CGFloat = data?.user != nil ? 100 : 0
        return CGSize(width: collectionView.bounds.width, height: height)
    }
}

