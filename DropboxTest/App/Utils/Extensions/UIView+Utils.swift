//
//  UIView+Utils.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

extension UIView {
    func setupRoundedCorners(radius: CGFloat, corners: UIRectCorner = [.topLeft, .topRight, .bottomLeft, .bottomRight]) {
        layer.masksToBounds = true
        var cornerMask = CACornerMask()
        if(corners.contains(.topLeft)) {
            cornerMask.insert(.layerMinXMinYCorner)
        }
        if(corners.contains(.topRight)) {
            cornerMask.insert(.layerMaxXMinYCorner)
        }
        if(corners.contains(.bottomLeft)) {
            cornerMask.insert(.layerMinXMaxYCorner)
        }
        if(corners.contains(.bottomRight)) {
            cornerMask.insert(.layerMaxXMaxYCorner)
        }
        layer.cornerRadius = radius
        layer.maskedCorners = cornerMask
    }
}
