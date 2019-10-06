//
//  Directory.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation

class Directory {
    let cursor: String
    let entries: [Entry]
    let hasMore: Bool
    
    init(cursor: String, entries: [Entry], hasMore: Bool) {
        self.cursor = cursor
        self.entries = entries
        self.hasMore = hasMore
    }
}

enum EntryType: String {
    case folder
    case file
}

class Entry {
    let type: EntryType
    let name: String
    let path: String?
    let size: Int
    let isDownloadable: Bool
    let share: ShareInfo?
    
    var typeExtension: String? {
        guard type == .file else { return nil }
        let components = name.components(separatedBy: ".")
        return components.count > 1 ? components.last : nil
    }
    
    init(type: EntryType, name: String, path: String?, size: Int, isDownloadable: Bool, share: ShareInfo? = nil) {
        self.type = type
        self.name = name
        self.path = path
        self.size = size
        self.isDownloadable = isDownloadable
        self.share = share
    }
}

struct ShareInfo {
    let id: Int
    let readOnly: Bool
}
