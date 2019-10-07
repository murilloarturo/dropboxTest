//
//  HeaderView.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

protocol HeaderViewDelegate: class {
    func didTapHeader()
}

class HeaderView: UICollectionReusableView {
    private weak var imageView: UIImageView?
    private weak var nameLabel: UILabel?
    private weak var emailLabel: UILabel?
    private weak var logoutButton: UIButton?
    weak var delegate: HeaderViewDelegate?
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    func update(with item: Any?) {
        guard let section = item as? UserSection else { return }
        if let url = section.image {
            imageView?.download(url: url)
        }
        nameLabel?.text = section.name
        emailLabel?.text = section.email
        logoutButton?.setTitle(section.actionButton, for: .normal)
    }
}

private extension HeaderView {
    func setupUI() {
        let view = UIView(frame: frame)
        addSubview(view)
        view.backgroundColor = .white
        view.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview()
        }
        view.setupRoundedCorners(radius: 10, corners: [.bottomLeft, .bottomRight])
        view.setupShadow(radius: 6, opacity: 0.4, offset: 3)
        
        let stackView = UIStackView(arrangedSubviews: [avatarView(), labels(), button()])
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.top.equalTo(30)
            maker.leading.equalTo(10)
            maker.bottom.equalTo(-20)
            maker.trailing.equalTo(-10)
        }
    }
    
    func avatarView() -> UIView {
        let view = UIView(frame: .zero)
        let avatarImageView = UIImageView(frame: .zero)
        view.addSubview(avatarImageView)
        imageView = avatarImageView
        avatarImageView.backgroundColor = .lightGray
        avatarImageView.setupRoundedCorners(radius: 30)
        avatarImageView.snp.makeConstraints { (maker) in
            maker.width.equalTo(60)
            maker.height.equalTo(60)
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(70)
        }
        
        return view
    }
    
    func labels() -> UIView {
        let nameLabel = UILabel(frame: .zero)
        nameLabel.font = AppStyle.font(type: .header2)
        nameLabel.textColor = .black
        self.nameLabel = nameLabel
        let emailLabel = UILabel(frame: .zero)
        emailLabel.textColor = .black
        emailLabel.font = AppStyle.font(type: .title)
        self.emailLabel = emailLabel
        let labelStackView = UIStackView(arrangedSubviews: [nameLabel, emailLabel])
        labelStackView.axis = .vertical
        labelStackView.alignment = .fill
        labelStackView.distribution = .fill
        labelStackView.spacing = -5
        
        return labelStackView
    }
    
    func button() -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        let button = UIButton(frame: .zero)
        button.titleLabel?.font = AppStyle.font(type: .subtitle)
        view.addSubview(button)
        button.setTitle(LocalizableString.logout.localized, for: .normal)
        button.backgroundColor = AppStyle.palette.blue
        button.setupRoundedCorners(radius: 20)
        button.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.height.equalTo(40)
            maker.centerY.equalToSuperview()
        }
        view.snp.makeConstraints { (maker) in
            maker.width.equalTo(100)
        }
        button
            .rx.tap.asObservable()
            .throttle(.milliseconds(250), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.delegate?.didTapHeader()
            })
            .disposed(by: disposeBag)
        
        return view
    }
}
