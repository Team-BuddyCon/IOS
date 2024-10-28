//
//  LoginViewController.swift
//  MOA
//
//  Created by 오원석 on 9/21/24.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

final class LoginViewController: BaseViewController {
    
    private lazy var loginIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: LOGIN_ICON))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: KAKAO_LOGIN_BUTTON_IMAGES), for: .normal)
        button.addTarget(self, action: #selector(tapKakaoLogin), for: .touchUpInside)
        return button
    }()
    
    let loginViewModel = LoginViewModel(authService: AuthService.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MOALogger.logd()
        setupAppearance()
        setupData()
    }
}

private extension LoginViewController {
    func setupAppearance() {
        view.backgroundColor = .white
        [loginIconImageView, kakaoLoginButton].forEach {
            view.addSubview($0)
        }
        
        loginIconImageView.snp.makeConstraints {
            $0.height.equalTo(118)
            $0.centerY.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.height.equalTo(54)
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(11.5)
        }
    }
    
    func setupData() {
        UserPreferences.setShouldEntryLogin()
        loginViewModel.tokenInfoDriver
            .drive { token in
                MOALogger.logi("\(token)")
                self.navigationController?.pushViewController(SignUpViewController(), animated: true)
            }.disposed(by: disposeBag)
    }
}

private extension LoginViewController {
    @objc func tapKakaoLogin() {
        MOALogger.logd()
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
        //loginViewModel.loginBykakao()
    }
}
