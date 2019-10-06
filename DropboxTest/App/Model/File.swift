//
//  File.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation

class File {
    var path: String
    var progress: Double
    var url: URL
    
    var name: String {
        let name = path.replacingOccurrences(of: "/", with: "")
        return name.components(separatedBy: ".").first ?? ""
    }
    
    init(path: String, progress: Double, url: URL) {
        self.path = path
        self.progress = progress
        self.url = url
    }
}
