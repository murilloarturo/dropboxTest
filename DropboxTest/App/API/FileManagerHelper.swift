//
//  FileManagerWrapper.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation

class FileManagerHelper {
    static func getDirectory(path: String) -> URL {
        let name = path.replacingOccurrences(of: "/", with: "")
        let manager = FileManager.default
        let directoryURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return directoryURL.appendingPathComponent("\(name)")
    }
    
    static func deleteAllFiles() {
        let manager = FileManager.default
        let directoryURL = manager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let files: [URL] = (try? manager.contentsOfDirectory(at: directoryURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)) ?? []
        for file in files {
            try? manager.removeItem(at: file)
        }
    }
    
    static func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
}
