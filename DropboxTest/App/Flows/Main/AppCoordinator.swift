//
//  AppCoordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift

final class AppCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    private weak var window: UIWindow?
    weak var navigation: UINavigationController?
    var childs = [Coordinator]()
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func start() {
        let coordinator = BrowserCoordinator()
        childs.append(coordinator)
        navigation = coordinator.navigation
        window?.rootViewController = coordinator.navigation
        window?.makeKeyAndVisible()
        coordinator
            .onState
            .subscribe(onNext: { [weak self] (state) in
                self?.handle(browserState: state)
            })
            .disposed(by: disposeBag)
        coordinator.start()
    }
    
    func userFinishedLogin() {
        navigation?.dismiss(animated: true, completion: nil)
    }
}

private extension AppCoordinator {
    func handle(browserState: BrowserState) {
        switch browserState {
        case .login:
            startLogin()
        }
    }
    
    func startLogin() {
        let coordinator = LoginCoordinator(navigation: navigation)
        childs.append(coordinator)
        coordinator.start()
    }
}
