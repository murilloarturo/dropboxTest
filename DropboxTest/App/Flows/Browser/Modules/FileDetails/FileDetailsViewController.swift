//
//  FileDetailsViewController.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class FileDetailsViewController: UIViewController {
    private weak var collectionView: UICollectionView?
    private let viewModel: FileDetailsViewModel
    private let dataSource = FileDetailsDataSource()
    private let disposeBag = DisposeBag()
    
    init(viewModel: FileDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: Bundle.main)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
    }
}

private extension FileDetailsViewController {
    func setup() {
        view.backgroundColor = AppStyle.palette.grey
        setupUI()
        title = viewModel.title
        
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTapLeftButton))
        navigationItem.rightBarButtonItem = button
        
        bind()
    }
    
    @objc func didTapLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    func setupUI() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collectionView
        dataSource.collectionView = collectionView
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        collectionView.snp.makeConstraints { [unowned self] (maker) in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
    }
    
    func bind() {
        viewModel
            .items
            .drive(onNext: { [weak self] (items) in
                self?.dataSource.items = items
            })
            .disposed(by: disposeBag)
    }
}
