//
//  AppDelegate.swift
//  SaytvChatFake
//
//  Created by David Garcia on 24/5/22.
//

import UIKit
import Firebase
import FirebaseMessaging
import SaytvChat

let kApiToken = "$2y$10$m0qcFR4qVKS7h4eJlbLmcekPeSVv6En3mITCq0nZe0Rwm2r2JHZN."
//let kApiToken = "$2y$10$OCZKkMUlJL4PEytKCPcNiuWfjjoOoITdjnETRL9q5itIeLrr21Z26"

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let pushComponent = PushComponent()

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SayTvSdk.initialise(appName: "NewName")
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self

        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication,
                     didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }

    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if pushComponent.handlePush(response: userInfo) {
            completionHandler(.noData)
            return
        }
        
        completionHandler(.newData)
    }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("willPresent")
        if #available(iOS 14, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .badge, .sound])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        print("didReceive")
        
        //Client code...
        completionHandler()
    }
    
    func application(
      _ application: UIApplication,
      didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        Messaging.messaging().apnsToken = deviceToken
    }
}


extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging,
                   didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else {
            return
        }
        print("Firebase registration token internal: \(String(describing: fcmToken))")
        pushComponent.saveToken(fcmToken)
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
    }
}
