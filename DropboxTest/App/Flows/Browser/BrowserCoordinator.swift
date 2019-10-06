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
        let service = ServiceClient()
        let viewModel = BrowserViewModel(service: service)
        let viewController = BrowserViewController(viewModel: viewModel)
        navigation?.viewControllers = [viewController]
    }
}
