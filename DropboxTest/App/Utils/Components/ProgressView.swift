//
//  ProgressView.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import SnapKit

class ProgressView: UIView {
    private weak var progressBar: UIView?

    init(frame: CGRect, mainColor: UIColor, progressColor: UIColor) {
        super.init(frame: frame)
        
        setupUI()
        backgroundColor = progressColor
        progressBar?.backgroundColor = mainColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func update(progress: Double) {
        progressBar?.transform = CGAffineTransform(translationX: bounds.width * CGFloat(progress), y: 0)
    }
}

private extension ProgressView {
    func setupUI() {
        let view = UIView(frame: .zero)
        self.progressBar = view
        addSubview(view)
        view.backgroundColor = AppStyle.palette.blue
        view.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
}
