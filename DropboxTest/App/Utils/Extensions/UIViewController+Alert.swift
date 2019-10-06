//
//  UIViewController+Alert.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String,
                      message: String,
                      leftButtonTitle: String,
                      leftButtonHandler: ((UIAlertAction) -> Void)? = nil,
                      rightButtonTitle: String? = nil,
                      rightButtonHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let leftAction = UIAlertAction(title: leftButtonTitle, style: UIAlertAction.Style.default, handler: leftButtonHandler)
        alert.addAction(leftAction)
        if let rightTitle = rightButtonTitle {
            let rightAction = UIAlertAction(title: rightTitle, style: UIAlertAction.Style.default, handler: rightButtonHandler)
            alert.addAction(rightAction)
        }
        present(alert, animated: true, completion: nil)
    }
}
