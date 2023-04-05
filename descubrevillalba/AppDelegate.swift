//
//  AppDelegate.swift
//  descubrevillalba
//
//  Created by Antonio Moreno on 28/02/2022.
//

import UIKit
import AVFoundation
import Firebase
import FirebaseUI
import FirebaseAnalytics
import AdSupport
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    FirebaseApp.configure()
    StorageRef.storageRef = FirebaseUI.StorageReference()
    
    AnalyticsManager.shared.trackAppOpen()

    // Habilita el audio cuando el dispositivo está silenciado
    do {
      try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback,
                                                      mode: .default,
                                                      options: [.mixWithOthers, .allowAirPlay])
      try AVAudioSession.sharedInstance().setActive(true)
    } catch {
        print("AVAudioSessionCategoryPlayback not work")
    }

    askPermissions()
    return true
  }

  func askPermissions() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      if #available(iOS 14, *) {
        ATTrackingManager.requestTrackingAuthorization { status in
          DispatchQueue.main.async {
            switch status {
            case .authorized:
              // Authorized
              let idfa = ASIdentifierManager.shared().advertisingIdentifier
            case .denied,
                 .notDetermined,
                 .restricted:
              break
            @unknown default:
              break
            }
          }
        }
      } else {
        // Fallback on earlier versions
      }
    }
  }

  // MARK: UISceneSession Lifecycle

  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}

