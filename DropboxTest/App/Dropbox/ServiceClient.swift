//
//  ServiceClient.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyDropbox

enum ServiceError: LocalizedError {
    case common
    case unauthorized
    
    var errorDescription: String? {
        return ""
    }
}

class ServiceClient {
    private let session = DropboxWrapper.session
    
    func fetchUser() -> Single<User> {
        guard let client = dropboxClient() else { return .error(ServiceError.unauthorized) }
        return .create(subscribe: { (single) -> Disposable in
            client.users.getCurrentAccount().response(completionHandler: { [weak self] (response, error) in
                guard let self = self else { return }
                if let response = response {
                    let user = User(name: response.name.displayName)
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
    
    func fetchFolder() -> Single<String> {
        guard let client = dropboxClient() else { return .error(ServiceError.unauthorized) }
        return .create(subscribe: { (single) -> Disposable in
            client.files.listFolder(path: "")
                .response(completionHandler: { [weak self] (response, error) in
                    guard let self = self else { return }
                    if let response = response {
                        response.entries
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

private extension ServiceClient {
    func dropboxClient() -> DropboxClient? {
        let client = DropboxClientsManager.authorizedClient
        if client == nil {
            session.sessionExpired()
        }
        return client
    }
    
    func handle(error: ServiceError) {
        switch error {
        case .unauthorized:
            session.sessionExpired()
        default:
            break
        }
    }
}

extension CallError {
    func serviceError() -> ServiceError {
        switch self {
        case .authError, .accessError:
            return .unauthorized
        default:
            return .common
        }
    }
}
