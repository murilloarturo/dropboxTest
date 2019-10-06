//
//  DropboxWrapper.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift
import SwiftyDropbox

enum DropboxAuthResult {
    case success
    case failure
}

enum RequestError: LocalizedError {
    case common
    case unauthorized
    
    var errorDescription: String? {
        return LocalizableString.error.localized
    }
}

extension CallError {
    func serviceError() -> RequestError {
        switch self {
        case .authError, .accessError:
            return .unauthorized
        default:
            return .common
        }
    }
}

//MARK: - Wrapper
class DropboxWrapper: BrowserServiceClient {
    private let appKey = "nl8aqdftedjiwh3"
    private var authorizedSubject = BehaviorSubject<Bool>(value: true)
    var authorized: Observable<Bool> {
        return authorizedSubject.asObservable()
    }
}

//MARK: - DropboxSetup
extension DropboxWrapper {
    func setup() {
        DropboxClientsManager.setupWithAppKey(appKey)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        guard let result = DropboxClientsManager.handleRedirectURL(url) else { return }
        switch result {
        case .success:
            authorizedSubject.onNext(true)
        default:
            break
        }
    }
    
    func authorize(from controller: UIViewController?) {
        DropboxClientsManager
            .authorizeFromController(UIApplication.shared,
                                     controller: controller) { (url) in
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    func logout() {
        DropboxClientsManager
            .resetClients()
        DropboxClientsManager
            .unlinkClients()
        authorizedSubject.onNext(false)
    }
}

//MARK: - DropboxService
extension DropboxWrapper {
    func fetchUser() -> Single<User> {
        guard let client = currentClient() else { return .error(RequestError.unauthorized) }
        return .create(subscribe: { (single) -> Disposable in
            client
                .users
                .getCurrentAccount()
                .response(completionHandler: { [weak self] (response, error) in
                    guard let self = self else { return }
                    if let response = response {
                        let user = User(name: response.name.displayName,
                                        email: response.email,
                                        profileImage: response.profilePhotoUrl)
                        single(.success(user))
                    } else if let error = error {
                        let serviceError = error.serviceError()
                        self.handle(error: serviceError)
                        single(.error(serviceError))
                    }
                })
            return Disposables.create()
        })
    }
    
    func fetchDirectory(path: String, entriesLimit: Int?) -> Single<Directory> {
        guard let client = currentClient() else { return .error(RequestError.unauthorized) }
        return .create(subscribe: { (single) -> Disposable in
            var limit: UInt32? = nil
            if let entriesLimit = entriesLimit {
                limit = UInt32(entriesLimit)
            }
            client
                .files
                .listFolder(path: path, limit: limit)
                .response(completionHandler: { [weak self] (response, error) in
                    guard let self = self else { return }
                    if let response = response {
                        let newEntries = response.entries.compactMap { $0.parseEntry() }
                        let directory = Directory(cursor: response.cursor, entries: newEntries, hasMore: response.hasMore)
                        single(.success(directory))
                    } else if let error = error {
                        let serviceError = error.serviceError()
                        self.handle(error: serviceError)
                        single(.error(serviceError))
                    }
                })
            
            return Disposables.create()
        })
    }
    
    func fetchNextDirectoryPage(cursor: String) -> Single<Directory> {
        guard let client = currentClient() else { return .error(RequestError.unauthorized) }
        return .create(subscribe: { (single) -> Disposable in
            client
                .files
                .listFolderContinue(cursor: cursor)
                .response(completionHandler: { [weak self] (response, error) in
                    guard let self = self else { return }
                    if let response = response {
                        let newEntries = response.entries.compactMap { $0.parseEntry() }
                        let directory = Directory(cursor: response.cursor, entries: newEntries, hasMore: response.hasMore)
                        single(.success(directory))
                    } else if let error = error {
                        let serviceError = error.serviceError()
                        self.handle(error: serviceError)
                        single(.error(serviceError))
                    }
                })
            
            return Disposables.create()
        })
    }
}

//MARK: - Private
private extension DropboxWrapper {
    func currentClient() -> DropboxClient? {
        guard let client = DropboxClientsManager.authorizedClient else {
            logout()
            return nil
        }
        return client
    }
    
    func handle(error: RequestError) {
        switch error {
        case .unauthorized:
            logout()
        default:
            break
        }
    }
}

extension Files.Metadata {
    func parseEntry() -> Entry? {
        switch self {
        case let file as Files.FileMetadata:
            return Entry(type: .file, name: file.name, path: file.pathLower ?? "", size: Int(file.size), isDownloadable: file.isDownloadable)
        case let folder as Files.FolderMetadata:
            return Entry(type: .folder, name: folder.name, path: folder.pathLower ?? "", size: 0, isDownloadable: false)
        default:
            return nil
        }
    }
}
