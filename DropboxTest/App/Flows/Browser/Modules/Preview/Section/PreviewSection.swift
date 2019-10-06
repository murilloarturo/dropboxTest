//
//  PreviewSection.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation
import QuickLook

class PreviewSection: NSObject, QLPreviewItem {
    var title: String
    var progress: Double
    var url: URL
    
    var previewItemURL: URL? {
        return url
    }
    
    init(title: String, progress: Double, url: URL) {
        self.title = title
        self.progress = progress
        self.url = url
    }
}
