//
//  BrowserViewModel.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum BrowserState {
    case logout
    case show(entry: Entry)
}

class BrowserViewModel {
    private let disposeBag = DisposeBag()
    private let service: ServiceClient
    private let showUser: Bool
    private var user: User?
    private var entries: [Entry] = []
    private let itemsSubject = BehaviorSubject<DirectorySection?>(value: nil)
    var items: Driver<DirectorySection?> {
        return itemsSubject.asDriver(onErrorJustReturn: nil)
    }
    private let stateSubject = PublishSubject<BrowserState>()
    var state: Observable<BrowserState> {
        return stateSubject.asObservable()
    }
    private let errorSubject = PublishSubject<Error>()
    var error: Observable<Error> {
        return errorSubject.asObservable()
    }
    var title: String {
        return showUser ? LocalizableString.home.localized : LocalizableString.files.localized
    }
    
    init(service: ServiceClient, showUser: Bool) {
        self.service = service
        self.showUser = showUser
        
        fetchData()
    }
    
    func handle(action: BrowserAction) {
        switch action {
        case .didTapHeader:
            stateSubject.onNext(.logout)
        case .didSelect(let entry):
            stateSubject.onNext(.show(entry: entry))
        case .showMore:
            fetchNextPage()
        }
    }
}

private extension BrowserViewModel {
    func fetchData() {
        if showUser {
            Observable.combineLatest(service.fetchUser().asObservable(), service.fetchEntries().asObservable())
                .subscribe(onNext: { [weak self] (data) in
                    self?.handle(user: data.0, entries: data.1)
                }, onError: { [weak self] (error) in
                    self?.handle(error: error)
                })
                .disposed(by: disposeBag)
        } else {
            service.fetchEntries()
                .subscribe(onSuccess: { [weak self] (entries) in
                    self?.handle(newEntries: entries)
                }) { [weak self] (error) in
                    self?.handle(error: error)
                }
                .disposed(by: disposeBag)
        }
    }
    
    func fetchNextPage() {
        service.fetchNextPage()
            .subscribe(onSuccess: { [weak self] (entries) in
                self?.handle(newEntries: entries)
            }) { [weak self] (error) in
                self?.handle(error: error)
            }
            .disposed(by: disposeBag)
    }
    
    func updateItems() {
        var userSection: UserSection? = nil
        if let user = user, showUser {
            let imageURL = URL(string: user.profileImage ?? "")
            userSection = UserSection(image: imageURL, name: user.name, email: user.email, actionButton: LocalizableString.logout.localized)
        }
        let sections = entries.map { (entry) -> EntrySection in
            return EntrySection(icon: nil, title: entry.name)
        }
        let directorySection = DirectorySection(user: userSection, entries: sections)
        itemsSubject.onNext(directorySection)
    }
    
    func handle(newEntries: [Entry]) {
        entries.append(contentsOf: newEntries)
        updateItems()
    }
    
    func handle(user: User, entries: [Entry]) {
        self.user = user
        self.entries = entries
        updateItems()
    }
    
    func handle(error: Error) {
        switch error {
        case let requestError as RequestError where requestError == .unauthorized:
            break
        default:
            errorSubject.onNext(error)
        }
    }
}
