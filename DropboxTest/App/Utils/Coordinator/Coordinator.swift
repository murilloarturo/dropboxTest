//
//  Coordinator.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift

protocol Coordinator {
    var childs: [Coordinator] { get }
    var navigation: UINavigationController? { get }
    
    func start()
}
