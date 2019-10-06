//
//  FooterView.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import SnapKit

class FooterView: UICollectionReusableView {
    private weak var activityIndicator: UIActivityIndicatorView?
    private weak var titleLabel: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func update(with item: Any?) {
        guard let footer = item as? FooterSection else { return }
        footer.showMore ? activityIndicator?.startAnimating() : activityIndicator?.stopAnimating()
        titleLabel?.text = footer.title
        titleLabel?.isHidden = footer.showMore
    }
}

private extension FooterView {
    func setupUI() {
        let label = UILabel(frame: .zero)
        self.titleLabel = label
        label.textColor = .lightGray
        label.textAlignment = .center
        label.font = AppStyle.font(type: .subtitle)
        label.isHidden = true
        addSubview(label)
        label.snp.makeConstraints { (maker) in
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        self.activityIndicator = activityIndicator
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
    }
}
