//
//  FileCell.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import SnapKit

class FileCell: UICollectionViewCell {
    private weak var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let label = UILabel(frame: .zero)
        addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        label.text = "hola"
        
        backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func update(with item: Any?) {
        
    }
}
