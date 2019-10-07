//
//  PreviewViewModel.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum PreviewViewState {
    case showInfo(file: File)
}

class PreviewViewModel {
    private let disposeBag = DisposeBag()
    private let service: ServiceClient
    private var itemSubject = BehaviorRelay<File?>(value: nil)
    var item: Driver<PreviewSection?> {
        return itemSubject.map{ [weak self] in self?.mapFile(file: $0) }.asDriver(onErrorJustReturn: nil)
    }
    private let errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        return errorSubject.asObservable()
    }
    private let stateSubject = PublishSubject<PreviewViewState>()
    var state: Observable<PreviewViewState> {
        return stateSubject.asObservable()
    }
    
    init(service: ServiceClient) {
        self.service = service
        
        bind()
    }
    
    func handle(action: PreviewViewAction) {
        switch action {
        case .didTapInfo:
            guard let file = itemSubject.value else { return }
            stateSubject.onNext(.showInfo(file: file))
        }
    }
}

private extension PreviewViewModel {
    func bind() {
        service
            .fetchFile()
            .subscribe(onNext: { [weak self] (file) in
                self?.itemSubject.accept(file)
            }, onError: { [weak self] (error) in
                self?.errorSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    func mapFile(file: File?) -> PreviewSection? {
        guard let file = file else { return nil }
        let name = file.name
        let section = PreviewSection(title: name, progress: file.progress, url: file.url)
        return section
    }
}
