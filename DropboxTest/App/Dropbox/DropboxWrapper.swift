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

class DropboxWrapper {
    private static let appKey = "nl8aqdftedjiwh3"
    static let session = DropboxWrapper()
    private var authorizedSubject = PublishSubject<Bool>()
    var authorized: Observable<Bool> {
        return authorizedSubject.asObservable()
    }
    
    static func setup() {
        DropboxClientsManager.setupWithAppKey(appKey)
    }
    
    static func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) {
        guard let result = DropboxClientsManager.handleRedirectURL(url) else { return }
        switch result {
        case .success:
            session.authorizedSubject.onNext(true)
        default:
            break
        }
    }
    
    static func authorize(from controller: UIViewController?) {
        DropboxClientsManager
            .authorizeFromController(UIApplication.shared,
                                     controller: controller) { (url) in
                                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    static func logout() {
        DropboxClientsManager
            .resetClients()
        DropboxClientsManager
            .unlinkClients()
        session.sessionExpired()
    }
    
    func sessionExpired() {
        authorizedSubject.onNext(false)
    }
}
