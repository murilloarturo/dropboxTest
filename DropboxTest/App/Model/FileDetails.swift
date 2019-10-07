//
//  FileDetails.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation

struct FileDimensions {
    var height: Int
    var width: Int
}

class FileDetails {
    var name: String
    var size: Int
    var modified: Date?
    var dimensions: FileDimensions?
    
    init(name: String, size: Int, modified: Date?, dimensions: FileDimensions?) {
        self.name = name
        self.size = size
        self.modified = modified
        self.dimensions = dimensions
    }
}
