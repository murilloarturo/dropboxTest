//
//  FileDetailsViewModel.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class FileDetailsViewModel {
    private let disposeBag = DisposeBag()
    private let service: ServiceClient
    private var itemSubject = BehaviorRelay<[DetailsSection]>(value: [])
    var items: Driver<[DetailsSection]> {
        return itemSubject.asDriver(onErrorJustReturn: [])
    }
    private let errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        return errorSubject.asObservable()
    }
    var title: String {
        return LocalizableString.fileInfo.localized
    }
    
    init(service: ServiceClient) {
        self.service = service
        
        bind()
    }
}

private extension FileDetailsViewModel {
    func bind() {
        service
            .fetchDetails()
            .subscribe(onSuccess: { [weak self] (details) in
                self?.handle(details: details)
            }) { [weak self] (error) in
                self?.errorSubject.onNext(error)
            }
            .disposed(by: disposeBag)
    }
    
    func handle(details: FileDetails) {
        var items: [DetailsSection] = []
        let nameSection = DetailsSection(title: LocalizableString.name.localized, value: details.name)
        let sizeValue = "\(details.size / 1000) KB (\(details.size) bytes)"
        let sizeSection = DetailsSection(title: LocalizableString.size.localized, value: sizeValue)
        items = [nameSection, sizeSection]
        if let dimensions = details.dimensions {
            let dimensionsValue = "\(dimensions.width) x \(dimensions.height) pixels"
            items.append(DetailsSection(title: LocalizableString.dimensions.localized, value: dimensionsValue))
        }
        if let date = details.modified {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyy HH:mm:ss"
            items.append(DetailsSection(title: LocalizableString.modified.localized, value: formatter.string(from: date)))
        }
        itemSubject.accept(items)
    }
}
