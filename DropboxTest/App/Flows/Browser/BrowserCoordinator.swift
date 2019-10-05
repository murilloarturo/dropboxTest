//
//  BrowserCoordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift

enum BrowserState {
    case login
}

final class BrowserCoordinator: Coordinator {
    private let disposeBag = DisposeBag()
    var navigation: UINavigationController? = UINavigationController()
    var childs = [Coordinator]()
    private var stateSubject = PublishSubject<BrowserState>()
    var onState: Observable<BrowserState> {
        return stateSubject.asObservable()
    }
    
    init() { }
    
    func start() {
        let viewModel = BrowserViewModel()
        let viewController = BrowserViewController(viewModel: viewModel)
        navigation?.viewControllers = [viewController]
        
        stateSubject.onNext(.login)
    }
}
