//
//  LoginCoordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift

final class LoginCoordinator: Coordinator {
    weak var baseNavigation: UINavigationController?
    private let disposeBag = DisposeBag()
    weak var navigation: UINavigationController?
    var childs = [Coordinator]()
    
    init(navigation: UINavigationController?) {
        self.baseNavigation = navigation
    }
    
    func start() {
        let viewController = LoginViewController()
        let navigation = UINavigationController(rootViewController: viewController)
        baseNavigation?.present(navigation, animated: true, completion: nil)
        self.navigation = navigation
        viewController.onState
            .subscribe(onNext: { [weak self] (state) in
                switch state {
                case .login:
                    self?.startSignIn()
                }
            })
            .disposed(by: disposeBag)
    }
}

private extension LoginCoordinator {
    func startSignIn() {
        Browser.session.authorize(from: navigation)
    }
}
