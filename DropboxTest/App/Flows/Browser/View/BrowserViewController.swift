//
//  BrowserViewController.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift

enum BrowserAction {
    case fetchData
    case logout
}

class BrowserViewController: UIViewController {
    private let viewModel: BrowserViewModel

    init(viewModel: BrowserViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension BrowserViewController {
    func setup() {
        view.backgroundColor = .white
        
        let rightButton = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = rightButton
        
        viewModel.action.onNext(.fetchData)
    }
    
    @objc func logout() {
        viewModel.action.onNext(.logout)
    }
}
