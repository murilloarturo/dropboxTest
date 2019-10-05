//
//  LoginViewController.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

enum LoginState {
    case login
}

class LoginViewController: UIViewController {
    private weak var loginButton: UIButton?
    private let disposeBag = DisposeBag()
    private let stateSubject = PublishSubject<LoginState>()
    var onState: Observable<LoginState> {
        return stateSubject.asObservable()
    }
    
    init() {
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigation()
    }
    
}

extension LoginViewController {
    func setup() {
        view.backgroundColor = .white
        setupUI()
        bind()
    }
    
    func setupUI() {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "dropboxLogo"))
        imageView.contentMode = .scaleAspectFill
        imageView.snp.makeConstraints { (maker) in
            maker.height.equalTo(100)
        }
        let button = UIButton(frame: .zero)
        button.setTitle(LocalizableString.signIn.localized, for: .normal)
        button.snp.makeConstraints { (maker) in
            maker.height.equalTo(50)
        }
        loginButton = button
        loginButton?.backgroundColor = AppStyle.palette.blue
        loginButton?.setupRoundedCorners(radius: 5)
        let stackView = UIStackView(arrangedSubviews: [imageView, button])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        view.addSubview(stackView)
        stackView.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(view)
            maker.leading.equalTo(10)
            maker.trailing.equalTo(-10)
        }
    }
    
    func bind() {
        loginButton?
            .rx.tap.asObservable()
            .throttle(.milliseconds(250), latest: false, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] () in
                self?.stateSubject.onNext(.login)
            })
            .disposed(by: disposeBag)
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.isTranslucent = true
    }
}
