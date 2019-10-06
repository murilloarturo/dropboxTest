//
//  User.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation

class User {
    var name: String
    var email: String
    var profileImage: String?
    
    init(name: String, email: String, profileImage: String?) {
        self.name = name
        self.email = email
        self.profileImage = profileImage
    }
}
