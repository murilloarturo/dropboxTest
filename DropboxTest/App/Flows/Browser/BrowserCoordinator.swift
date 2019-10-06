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
        viewModel
            .state
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
            navigation?.presentAlert(title: LocalizableString.sureLogout.localized, message: "", leftButtonTitle: LocalizableString.no.localized, rightButtonTitle: LocalizableString.yes.localized, rightButtonHandler: { (_) in
                Browser.session.logout()
            })
        case .show(let entry):
            entry.type == .folder ? showFolderDirectory(entry: entry) : showFile(entry: entry)
        }
    }
    
    func showFolderDirectory(entry: Entry) {
        guard let path = entry.path, entry.type == .folder else { return }
        let service = ServiceClient(client: Browser.session, path: path, entriesLimit: 20)
        let viewModel = BrowserViewModel(service: service, showUser: false, title: entry.name)
        let viewController = BrowserViewController(viewModel: viewModel)
        navigation?.pushViewController(viewController, animated: true)
        viewModel
            .state
            .subscribe(onNext: { [weak self] (state) in
                self?.handle(state: state)
            })
            .disposed(by: disposeBag)
    }
    
    func showFile(entry: Entry) {
        guard let path = entry.path, entry.type == .file else { return }
        let service = ServiceClient(client: Browser.session, path: path, entriesLimit: 20)
        let viewModel = PreviewViewModel(service: service)
        let viewController = PreviewViewController(viewModel: viewModel)
        navigation?.pushViewController(viewController, animated: true)
    }
}
