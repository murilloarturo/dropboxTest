//
//  AppFont.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

enum FontStyle: String {
    case bold = "HelveticaNeue-Bold"
    case boldItalic = "HelveticaNeue-BoldItalic"
    case light = "HelveticaNeue-Light"
    case lightItalic = "HelveticaNeue-LightItalic"
    case medium = "HelveticaNeue-Medium"
    case mediumItalic = "HelveticaNeue-MediumItalic"
    case regular = "HelveticaNeue"
    case regularItalic = "HelveticaNeue-Italic"
    case thin = "HelveticaNeue-Thin"
    case thinItalic = "HelveticaNeue-ThinItalic"
    
    func font(size: CGFloat) -> UIFont? {
        return UIFont(name: rawValue, size: size)
    }
}

enum FontType {
    case header
    case title
    case subtitle
    
    var style: FontStyle {
        switch self {
        case .header:
            return .bold
        case .title:
            return .medium
        case .subtitle:
            return .regular
        }
    }
    
    var size: CGFloat {
        switch self {
        case .header:
            return 28
        case .title:
            return 15
        case .subtitle:
            return 13
        }
    }
}
