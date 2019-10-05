//
//  Coordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit

protocol Coordinator {
    var childs: [Coordinator] { get set }
    var navigation: UINavigationController? { get set }
    
    func start()
}
