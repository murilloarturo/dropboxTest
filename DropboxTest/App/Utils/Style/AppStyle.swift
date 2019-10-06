//
//  AppStyle.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

class AppStyle {
    static let palette = ColorPalette()

    private init() { }
    
    @nonobjc class func font(type: FontType) -> UIFont {
        return UIFont.appFont(type: type) ?? UIFont.defaultFont(size: type.size)
    }
}

private extension UIFont {
    class func appFont(type: FontType) -> UIFont? {
        return type.style.font(size: type.size)
    }
    
    class func defaultFont(size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size)
    }
}
