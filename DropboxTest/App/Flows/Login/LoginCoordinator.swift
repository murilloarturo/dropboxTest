//
//  LoginCoordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyDropbox

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
        baseNavigation?.present(navigation, animated: false, completion: nil)
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
        DropboxClientsManager
            .authorizeFromController(UIApplication.shared,
                                     controller: navigation) { (url) in
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
