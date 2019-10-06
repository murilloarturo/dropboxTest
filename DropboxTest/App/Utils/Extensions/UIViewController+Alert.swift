//
//  UIViewController+Alert.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentAlert(title: String,  message: String, buttonTitle: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: buttonTitle, style: UIAlertAction.Style.default, handler: handler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
