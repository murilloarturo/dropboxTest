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
        
        bind()
    }
    
    func start() {
        let coordinator = BrowserCoordinator()
        childs.append(coordinator)
        navigation = coordinator.navigation
        window?.rootViewController = coordinator.navigation
        window?.makeKeyAndVisible()
        coordinator.start()
    }
}

private extension AppCoordinator {
    func bind() {
        DropboxWrapper
            .session
            .authorized
            .subscribe(onNext: { [weak self] (authorized) in
                guard let self = self else { return }
                if authorized {
                    self.appAuthorized()
                } else {
                    self.startLogin()
                }
            })
            .disposed(by: disposeBag)
    }
    
    func startLogin() {
        let coordinator = LoginCoordinator(navigation: navigation)
        childs.append(coordinator)
        coordinator.start()
    }
    
    func appAuthorized() {
        navigation?.dismiss(animated: true, completion: nil)
        childs.removeAll { (coordinator) -> Bool in
            return coordinator is LoginCoordinator
        }
    }
}
