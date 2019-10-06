//
//  PreviewViewController.swift
//  DropboxTest
//
//  Created by Arturo Murillo on 10/6/19.
//  Copyright © 2019 Arturo Murillo. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import QuickLook

class PreviewViewController: UIViewController {
    private weak var progressView: ProgressView?
    private weak var itemLabel: UILabel?
    private weak var progressContainerView: UIView?
    private weak var preview: QLPreviewController?
    private let viewModel: PreviewViewModel
    private let disposeBag = DisposeBag()
    private var items: [PreviewSection] = []
    
    init(viewModel: PreviewViewModel) {
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.prefersLargeTitles = false
    }
}

private extension PreviewViewController {
    func setup() {
        view.backgroundColor = .white
        setupUI()
        bind()
    }
    
    func setupUI() {
        let progressView = ProgressView(frame: .zero, mainColor: .lightGray, progressColor: AppStyle.palette.blue)
        self.progressView = progressView
        progressView.snp.makeConstraints { (maker) in
            maker.height.equalTo(5)
        }
        progressView.setupRoundedCorners(radius: 2.5)
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingMiddle
        itemLabel = label
        let stackView = UIStackView(arrangedSubviews: [label, progressView])
        progressContainerView = stackView
        progressContainerView?.alpha = 0
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.snp.makeConstraints { [unowned self] (maker) in
            maker.centerY.equalToSuperview()
            maker.centerX.equalToSuperview()
            maker.width.equalTo(self.view.bounds.width * 0.8)
            maker.height.equalTo(50)
        }
        
        let preview = QLPreviewController(nibName: nil, bundle: Bundle.main)
        view.addSubview(preview.view)
        self.preview = preview
        addChild(preview)
        preview.view.snp.makeConstraints { [unowned self] (maker) in
            maker.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            maker.leading.equalToSuperview()
            maker.bottom.equalToSuperview()
            maker.trailing.equalToSuperview()
        }
        preview.dataSource = self
        preview.view.alpha = 0
    }
    
    func bind() {
        viewModel
            .item
            .drive(onNext: { [weak self] (file) in
                self?.update(item: file)
            })
            .disposed(by: disposeBag)
    }
    
    func update(item: PreviewSection?) {
        guard let item = item else { return }
        title = item.title
        itemLabel?.text = item.title
        progressView?.update(progress: item.progress)
        guard item.progress >= 1 else {
            progressContainerView?.alpha = 1
            return
        }
        self.items = [item]
        preview?.reloadData()
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.preview?.view.alpha = 1
        }
    }
}

extension PreviewViewController: QLPreviewControllerDataSource {
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return items.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return items[index]
    }
}
