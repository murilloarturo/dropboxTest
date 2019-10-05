//
//  ColorPalette.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

struct ColorPalette {
    var blue: UIColor {
        return UIColor(red: 0, green: 96, blue: 255)
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) {
        let newRed = CGFloat(red) / 255
        let newGreen = CGFloat(green) / 255
        let newBlue = CGFloat(blue) / 255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
}
