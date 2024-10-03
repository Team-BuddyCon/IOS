//
//  SignUpViewController.swift
//  MOA
//
//  Created by 오원석 on 10/1/24.
//

import UIKit
import SnapKit
import RxSwift

final class SignUpViewController: BaseViewController {
    
    private let titleLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.setTextWithLineHeight(
            text: SIGNUP_TERMS_GUIDE_TITLE,
            font: pretendard_bold,
            size: 22.0,
            lineSpacing: 30.8
        )
        label.textAlignment = .left
        return label
    }()
    
    private lazy var allSignUpCheckBox: SignUpCheckBox = {
        let checkBox = SignUpCheckBox(frame: .zero,text: SIGNUP_AGREE_TO_ALL)
        return checkBox
    }()
    
    private lazy var termsOfUseSignUpCheckBox: SignUpCheckBox = {
        let checkBox = SignUpCheckBox(frame: .zero,text: SIGNUP_AGREE_TO_TERMS_OF_USE, hasMore: true)
        return checkBox
    }()
    
    private lazy var privacyPolicySignUpCheckBox: SignUpCheckBox = {
        let checkBox = SignUpCheckBox(frame: .zero,text: SIGNUP_AGREE_TO_PRIVACY_POLICY, hasMore: true)
        return checkBox
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .grey30
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        subscribe()
    }
}

private extension SignUpViewController {
    func setupAppearance() {
        setupNavigationBar()
        [
            titleLable,
            allSignUpCheckBox,
            termsOfUseSignUpCheckBox,
            privacyPolicySignUpCheckBox,
            dividerView
        ].forEach {
            view.addSubview($0)
        }
        
        titleLable.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        allSignUpCheckBox.snp.makeConstraints {
            $0.top.equalTo(titleLable.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(allSignUpCheckBox.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(1)
        }
        
        termsOfUseSignUpCheckBox.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
        
        privacyPolicySignUpCheckBox.snp.makeConstraints {
            $0.top.equalTo(termsOfUseSignUpCheckBox.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.height.equalTo(24)
        }
    }
    
    func setupNavigationBar() {
        navigationItem.hidesBackButton = true
        let backButtonItem = UIBarButtonItem(
            image: UIImage(named: BACK_BUTTON_IMAGE_ASSET),
            style: .plain,
            target: self,
            action: #selector(tapBackButton)
        )
        backButtonItem.tintColor = .grey90
        navigationItem.leftBarButtonItem = backButtonItem
        navigationItem.title = SIGNUP_TITLE
    }
    
    func subscribe() {
        allSignUpCheckBox.checkState
            .distinctUntilChanged()
            .drive { [weak self] check in
                guard let self = self else { return }
                if !check && termsOfUseSignUpCheckBox.isCheckedRelay.value != privacyPolicySignUpCheckBox.isCheckedRelay.value { return }
                termsOfUseSignUpCheckBox.isCheckedRelay.accept(check)
                privacyPolicySignUpCheckBox.isCheckedRelay.accept(check)
            }.disposed(by: disposeBag)
        
        termsOfUseSignUpCheckBox.checkState
            .distinctUntilChanged()
            .drive { [weak self] check in
                guard let self = self else { return }
                
                if check && privacyPolicySignUpCheckBox.isCheckedRelay.value {
                    allSignUpCheckBox.isCheckedRelay.accept(true)
                } else if !check && !privacyPolicySignUpCheckBox.isCheckedRelay.value {
                    allSignUpCheckBox.isCheckedRelay.accept(false)
                } else {
                    if allSignUpCheckBox.isCheckedRelay.value {
                        allSignUpCheckBox.isCheckedRelay.accept(false)
                    }
                }
            }.disposed(by: disposeBag)
        
        privacyPolicySignUpCheckBox.checkState
            .distinctUntilChanged()
            .drive { [weak self] check in
                guard let self = self else { return }
                
                if check && termsOfUseSignUpCheckBox.isCheckedRelay.value {
                    allSignUpCheckBox.isCheckedRelay.accept(true)
                } else if !check && !termsOfUseSignUpCheckBox.isCheckedRelay.value {
                    allSignUpCheckBox.isCheckedRelay.accept(false)
                } else {
                    if allSignUpCheckBox.isCheckedRelay.value {
                        allSignUpCheckBox.isCheckedRelay.accept(false)
                    }
                }
            }.disposed(by: disposeBag)
    }
}

private extension SignUpViewController {
    @objc func tapBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
