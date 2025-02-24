//
//  AppDelegate.swift
//  MOA
//
//  Created by 오원석 on 8/13/24.
//

import UIKit
import RxKakaoSDKCommon
import KakaoMapsSDK
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        MOALogger.logd()
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        MOALogger.logd()
        guard let appKey = Bundle.main.infoDictionary?["KakaoApiKey"] as? String else {
            return false
        }
        UNUserNotificationCenter.current().delegate = self
        RxKakaoSDK.initSDK(appKey: appKey)
        SDKInitializer.InitSDK(appKey: appKey)
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        MOALogger.logd()
        completionHandler([.list, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        MOALogger.logd()
        completionHandler()
    }
}
