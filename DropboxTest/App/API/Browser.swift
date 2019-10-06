//
//  Browser.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift

protocol BrowserSetup {
    func setup()
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
    func authorize(from controller: UIViewController?)
    func logout()
}

protocol BrowserService {
    func fetchUser() -> Single<User>
    func fetchDirectory(path: String, entriesLimit: Int?) -> Single<Directory>
    func fetchNextDirectoryPage(cursor: String) -> Single<Directory>
    func fetchFile(_ file: File) -> Observable<File> 
}

protocol BrowserServiceClient: BrowserSetup, BrowserService {
    var authorized: Observable<Bool> { get }
}

class Browser {
    static let session: BrowserServiceClient = DropboxWrapper()
}
