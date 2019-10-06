//
//  UICollectionView+Register.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

extension UICollectionView {
    public func registerNibForSuplementaryView<T: UIView>(with cellType: T.Type, kind: String) {
        register(cellType, forSupplementaryViewOfKind: kind, withReuseIdentifier: String(describing: cellType))
    }
    
    public func registerNibForCell<T: UICollectionViewCell>(with cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
    
    public func dequeueSuplementaryView<T: UICollectionReusableView>(with cellType: T.Type, forIndexPath indexPath: IndexPath, kind: String) -> T {
        return dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: String(describing: cellType), for: indexPath) as! T
    }
    
    public func dequeueReusableCell<T: UICollectionViewCell>(with cellType: T.Type, forIndexPath indexPath: IndexPath) -> T {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath) as! T
    }
}
