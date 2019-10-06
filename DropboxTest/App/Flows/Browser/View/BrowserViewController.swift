//
//  BrowserViewController.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/5/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

enum BrowserAction {
    case didTapHeader
    case didSelect(index: Int)
    case showMore
}

class BrowserViewController: UIViewController {
    private weak var collectionView: UICollectionView?
    private weak var loaderView: UIView?
    private weak var activityIndicator: UIActivityIndicatorView?
    private let dataSource = BrowserDataSource()
    private let viewModel: BrowserViewModel
    private let disposeBag = DisposeBag()

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
        setupUI()
        view.backgroundColor = .white
        bind()
        dataSource.delegate = self
    }
    
    func bind() {
        viewModel
            .items
            .drive(onNext: { [weak self] (items) in
                self?.handle(data: items)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .error
            .subscribe(onNext: { [weak self] (error) in
                self?.presentAlert(title: LocalizableString.oops.localized,
                                   message: error.localizedDescription,
                                   leftButtonTitle: LocalizableString.ok.localized)
            })
            .disposed(by: disposeBag)
    }
    
    func handle(data: DirectorySection?) {
        if let data = data {
            self.title = self.viewModel.title
            self.dataSource.data = data
            self.hideLoader()
        } else {
            self.loaderView?.alpha = 1
            self.activityIndicator?.startAnimating()
        }
    }
    
    func hideLoader() {
        activityIndicator?.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.loaderView?.alpha = 0
        }
    }
    
    func setupUI() {
        title = viewModel.title
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: AppStyle.font(type: .header)
        ]
        
        let layout = ColumnFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView = collectionView
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        dataSource.collectionView = collectionView
        collectionView.backgroundColor = .white
        
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        self.activityIndicator = activityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview()
        }
        self.view.addSubview(view)
        view.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        self.loaderView = view
    }
    
    @objc func logout() {
        viewModel.handle(action: .didTapHeader)
    }
}

extension BrowserViewController: BrowserDataSourceDelegate {
    func didTapHeader() {
        viewModel.handle(action: .didTapHeader)
    }
    
    func didSelect(index: Int) {
        viewModel.handle(action: .didSelect(index: index))
    }
    
    func loadMore() {
        viewModel.handle(action: .showMore)
    }
}
