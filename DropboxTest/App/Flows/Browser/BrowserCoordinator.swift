//
//  BrowserCoordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift

final class BrowserCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    var navigation: UINavigationController? = UINavigationController()
    var childs = [Coordinator]()
    
    init() { }
    
    func start() {
        let service = ServiceClient(client: Browser.session, path: "", entriesLimit: 20)
        let viewModel = BrowserViewModel(service: service, showUser: true)
        let viewController = BrowserViewController(viewModel: viewModel)
        navigation?.viewControllers = [viewController]
        
        viewModel.state
            .subscribe(onNext: { [weak self] (state) in
                self?.handle(state: state)
            })
            .disposed(by: disposeBag)
    }
}

private extension BrowserCoordinator {
    func handle(state: BrowserState) {
        switch state {
        case .logout:
            break
        case .show(let entry):
            break
        }
    }
}
