//
//  FileDetailsDataSource.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

class FileDetailsDataSource: NSObject {
    weak var collectionView: UICollectionView? {
        didSet {
            setupCollectionView()
        }
    }
    var items: [DetailsSection] = [] {
        didSet {
            collectionView?.reloadData()
        }
    }
}

private extension FileDetailsDataSource {
    func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.registerNibForCell(with: DetailCell.self)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension FileDetailsDataSource: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: DetailCell.self, forIndexPath: indexPath)
        cell.update(with: items[indexPath.row])
        return cell
    }
}

extension FileDetailsDataSource: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 80)
    }
}
