//
//  DetailCell.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import SnapKit

class DetailCell: UICollectionViewCell {
    private weak var titleLabel: UILabel?
    private weak var valueLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    func update(with item: Any?) {
        guard let section = item as? DetailsSection else { return }
        titleLabel?.text = section.title
        valueLabel?.text = section.value
    }
}

private extension DetailCell {
    func setupUI() {
        backgroundColor = .white
        
        let titleLabel = UILabel(frame: .zero)
        titleLabel.textAlignment = .left
        titleLabel.textColor = .black
        titleLabel.font = AppStyle.font(type: .title)
        self.titleLabel = titleLabel
        
        let valueLabel = UILabel(frame: .zero)
        valueLabel.textAlignment = .right
        valueLabel.textColor = .black
        valueLabel.font = AppStyle.font(type: .title)
        self.valueLabel = valueLabel
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalTo(20)
            maker.bottom.equalToSuperview()
            maker.trailing.equalTo(-20)
        }
        
        let separator = UIView(frame: .zero)
        separator.backgroundColor = .groupTableViewBackground
        addSubview(separator)
        separator.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.height.equalTo(0.5)
        }
    }
}
