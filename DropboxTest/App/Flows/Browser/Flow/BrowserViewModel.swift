//
//  BrowserViewModel.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift

class BrowserViewModel {
    private let disposeBag = DisposeBag()
    private let service: ServiceClient
    var action = PublishSubject<BrowserAction>()
    
    init(service: ServiceClient) {
        self.service = service
        
        bind()
    }
}

private extension BrowserViewModel {
    func bind() {
        action
            .subscribe(onNext: { [weak self] (action) in
                self?.handle(action: action)
            })
            .disposed(by: disposeBag)
    }
    
    func handle(action: BrowserAction) {
        switch action {
        case .fetchData:
            service
                .fetchUser()
                .subscribe(onSuccess: { (user) in
                    
                }) { (error) in
                    
                }
                .disposed(by: disposeBag)
        case .logout:
            DropboxWrapper.logout()
        }
    }
}
