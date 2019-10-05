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

enum LoginState {
    case login
}

class LoginViewController: UIViewController {
    @IBOutlet private weak var loginButton: UIButton!
    private let disposeBag = DisposeBag()
    private let stateSubject = PublishSubject<LoginState>()
    var onState: Observable<LoginState> {
        return stateSubject.asObservable()
    }
    
    init() {
        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle.main)
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
        loginButton
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
