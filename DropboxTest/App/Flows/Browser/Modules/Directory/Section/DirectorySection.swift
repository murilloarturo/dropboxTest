//
//  DirectorySection.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

struct UserSection {
    var image: URL?
    var name: String
    var email: String
    var actionButton: String
}

struct EntrySection {
    var icon: UIImage?
    var title: String
    var fileType: String?
    var thumbnailIcon: UIImage?
}

struct FooterSection {
    var showMore: Bool
    var title: String
}

struct DirectorySection {
    var user: UserSection?
    var entries: [EntrySection]
    var footer: FooterSection
}
