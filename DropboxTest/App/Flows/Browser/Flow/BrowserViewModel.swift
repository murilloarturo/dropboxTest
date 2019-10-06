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
    private let title: String?
    private var user: User?
    private var entries: [Entry] = []
    private var isLoading = false
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
    var titleFormatted: String {
        guard !showUser else {
            return LocalizableString.home.localized
        }
        
        return title ?? LocalizableString.files.localized
    }
    
    init(service: ServiceClient, showUser: Bool, title: String? = nil) {
        self.service = service
        self.showUser = showUser
        self.title = title
        
        bind()
    }
    
    func handle(action: BrowserAction) {
        switch action {
        case .didTapHeader:
            stateSubject.onNext(.logout)
        case .didSelect(let index):
            let entry = entries[index]
            stateSubject.onNext(.show(entry: entry))
        case .showMore:
            fetchNextPage()
        }
    }
}

private extension BrowserViewModel {
    func bind() {
        Browser.session
            .authorized
            .subscribe(onNext: { [weak self] (authorized) in
                if authorized {
                    self?.fetchData()
                } else {
                    self?.itemsSubject.onNext(nil)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func fetchData() {
        guard !isLoading else { return }
        isLoading = true
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
        guard !isLoading else { return }
        isLoading = true
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
            return EntrySection(icon: entry.icon, title: entry.name, fileType: entry.typeExtension)
        }
        let footerSection = FooterSection(showMore: service.hasMoreContent, title: totalFilesTitle())
        let directorySection = DirectorySection(user: userSection, entries: sections, footer: footerSection)
        itemsSubject.onNext(directorySection)
    }
    
    func handle(newEntries: [Entry]) {
        entries.append(contentsOf: newEntries)
        updateItems()
        isLoading = false
    }
    
    func handle(user: User, entries: [Entry]) {
        self.user = user
        self.entries = entries
        updateItems()
        isLoading = false
    }
    
    func handle(error: Error) {
        switch error {
        case let requestError as RequestError where requestError == .unauthorized:
            break
        default:
            errorSubject.onNext(error)
        }
        isLoading = false
    }
    
    func totalFilesTitle() -> String {
        var numberOfFolders: Int = 0
        var numberOfFiles: Int = 0
        entries.forEach { (entry) in
            switch entry.type {
            case .folder:
                numberOfFolders += 1
            case .file:
                numberOfFiles += 1
            }
        }
        
        return LocalizableString.numberOfFiles.localized(with: ["\(numberOfFolders)", "\(numberOfFiles)"])
    }
}

extension Entry {
    var icon: UIImage? {
        switch type {
        case .file:
            return #imageLiteral(resourceName: "fileIcon")
        case .folder:
            return #imageLiteral(resourceName: "folderIcon")
        }
    }
}
