//
//  LocalizableString.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import Foundation

enum LocalizableString: String {
    case signIn
    case home
    case files
    case logout
    case email
    case error
    
    var localized: String {
        return localize()
    }
    
    func localized(with param: CVarArg) -> String {
        return String(format: localized, param)
    }
}

private extension LocalizableString {
    func localize() -> String {
        let mainBundle = Bundle.main
        return NSLocalizedString(rawValue, tableName: nil, bundle: mainBundle, value: "", comment: "")
    }
}
