//
//  GifticonRegisterViewController.swift
//  MOA
//
//  Created by 오원석 on 11/23/24.
//

import UIKit
import SnapKit

final class GifticonRegisterViewController: BaseViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let contentView = UIView()
        return contentView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let cancelButton: CommonButton = {
        let button = CommonButton(status: .cancel, title: CANCEL)
        return button
    }()
    
    private let saveButton: CommonButton = {
        let button = CommonButton(title: SAVE)
        return button
    }()
    
    private var image: UIImage?
    
    init(image: UIImage) {
        self.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MOALogger.logd()
        setupLayout()
    }

}

private extension GifticonRegisterViewController {
    func setupLayout() {
        setupTopBarWithBackButton(title: GIFTICON_REGISTER_TITLE)
        
        [scrollView, cancelButton, saveButton].forEach {
            view.addSubview($0)
        }
        
        let buttonW = getWidthByDivision(division: 2, exclude: 48)
        cancelButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(11.5)
            $0.height.equalTo(54)
            $0.width.equalTo(buttonW)
        }
        
        saveButton.snp.makeConstraints {
            $0.leading.equalTo(cancelButton.snp.trailing).offset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(11.5)
            $0.height.equalTo(54)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(buttonW)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(cancelButton.snp.top).offset(16)
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        [
            imageView
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(imageView.snp.width).multipliedBy(328 / 335.0)
        }
    }
}
