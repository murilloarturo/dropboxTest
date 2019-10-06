//
//  ServiceClient.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import RxSwift

class ServiceClient {
    private let client: BrowserService
    private let limit: Int
    private let path: String
    private var currentDirectory: Directory?
    
    var hasMoreContent: Bool {
        return currentDirectory?.hasMore ?? true
    }
    
    init(client: BrowserService, path: String, entriesLimit: Int = 20) {
        self.limit = entriesLimit
        self.client = client
        self.path = path
    }
    
    func fetchUser() -> Single<User> {
        return client.fetchUser()
    }
    
    func fetchEntries() -> Single<[Entry]> {
        return client
                .fetchDirectory(path: path, entriesLimit: limit)
                .do(onSuccess: { [weak self] (directory) in
                    self?.currentDirectory = directory
                })
                .map { $0.entries }
    }
    
    func fetchNextPage() -> Single<[Entry]> {
        guard let directory = currentDirectory, directory.hasMore else { return .just([]) }
        return client
                .fetchNextDirectoryPage(cursor: directory.cursor)
                .do(onSuccess: { [weak self] (directory) in
                    self?.currentDirectory = directory
                })
                .map { $0.entries }
    }
    
    func fetchFile() -> Observable<File> {
        let name = path.replacingOccurrences(of: "/", with: "")
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = directoryURL.appendingPathComponent(name)
        let file = File(path: path,
                        progress: 0,
                        url: destURL)
        if fileManager.fileExists(atPath: destURL.path) {
            file.progress = 1
            return .just(file)
        } else {
            return client
                .fetchFile(file)
        }
    }
}
