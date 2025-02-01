//
//  SceneDelegate.swift
//  MOA
//
//  Created by 오원석 on 8/13/24.
//

import UIKit
import KakaoSDKUser
import KakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import RxKakaoSDKUser
import RxKakaoSDKCommon
import FirebaseAuth
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        MOALogger.logd()
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()
        
        let isShouldEntryLogin = UserPreferences.isShouldEntryLogin()
        let currentUser = Auth.auth().currentUser
        var rootViewController = UIViewController()
        
        if isShouldEntryLogin {
            rootViewController = currentUser == nil ? UINavigationController(rootViewController: LoginViewController()) : UINavigationController(rootViewController: HomeTabBarController())
        } else {
            rootViewController = WalkThroughViewController()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            guard let window = self.window else { return }
            UIView.transition(
                with: window,
                duration: 0.5,
                options: [.transitionCrossDissolve],
                animations: {
                    window.rootViewController = rootViewController
                }
            )
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }
}

