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
    private weak var extensionLabel: UILabel?
    private weak var imageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func update(with item: Any?) {
        guard let entry = item as? EntrySection else { return }
        titleLabel?.text = entry.title
        imageView?.image = entry.icon
        extensionLabel?.text = entry.fileType?.uppercased()
    }
}

private extension FileCell {
    func setupUI() {
        backgroundColor = .white
        let imageContainer = UIView(frame: .zero)
        let imageView = UIImageView(frame: .zero)
        self.imageView = imageView
        imageView.contentMode = .scaleAspectFill
        imageContainer.addSubview(imageView)
        imageView.snp.makeConstraints { (maker) in
            maker.height.equalTo(60)
            maker.width.equalTo(80)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        
        let extLabel = UILabel(frame: .zero)
        extLabel.font = AppStyle.font(type: .title)
        extLabel.textAlignment = .center
        extLabel.minimumScaleFactor = 0.2
        extLabel.adjustsFontSizeToFitWidth = true
        extensionLabel = extLabel
        imageView.addSubview(extLabel)
        extLabel.snp.makeConstraints { (maker) in
            maker.leading.equalTo(15)
            maker.trailing.equalTo(-15)
            maker.centerY.equalToSuperview()
        }
        
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingMiddle
        label.font = AppStyle.font(type: .subtitle)
        titleLabel = label
        
        let stackView = UIStackView(arrangedSubviews: [imageContainer, label])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalTo(10)
            maker.bottom.equalToSuperview()
            maker.trailing.equalTo(-10)
        }
    }
}
