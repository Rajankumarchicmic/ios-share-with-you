//
//  AppDelegate.swift
//  sharedWithYouDemo
//
//  Created by ChicMic on 17/08/23.
//

import UIKit
import Branch
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import PusherSwift
// ...
      
@main
class AppDelegate: UIResponder, UIApplicationDelegate,PusherDelegate {
    var window: UIWindow?
    var pusher: Pusher!
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
       

       
             
             let options = PusherClientOptions(
                host: .cluster("ap2")
             )
             
             pusher = Pusher(
                key: "797113da27c2159a1c0a",
                options: options
             )
             
             pusher.delegate = self
             
             // subscribe to channel
             let channel = pusher.subscribe("my-channel")
             
             // bind a callback to handle an event
             let _ = channel.bind(eventName: "my-event", eventCallback: { (event: PusherEvent) in
                 if let data = event.data {
                     // you can parse the data as necessary
                     print(data)
                 }
             })
             
             pusher.connect()
             return true
        
    }

    func debugLog(message: String) {
         print(message)
       }
    
//    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler:
                     @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {

        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
          let url = userActivity.webpageURL,
          let _ = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        if let incomingURL = userActivity.webpageURL {
            if let urlComponents = URLComponents(url: incomingURL, resolvingAgainstBaseURL: true) {
                
                if let param = DynamicLinkGenerator().extractParametersFromURL(urlComponents){
                    if let rootViewController = window?.rootViewController as? UINavigationController {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let vc  = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                        vc.imageName = param["socialImageUrl"] ?? ""
                        vc.titleString = param["socialTitle"]?.replacingOccurrences(of: "+", with: " ") ?? ""
                        vc.desc = param["socialDescription"]?.replacingOccurrences(of: "+", with: " ") ?? ""
                        rootViewController.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        application.canOpenURL(url)
        print(url)

        return true
    }
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


//    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//      // if you are using the TEST key
//      Branch.setUseTestBranchKey(true)
//      // listener for Branch Deep Link data
//      Branch.getInstance().initSession(launchOptions: launchOptions) { (params, error) in
//        // do stuff with deep link data (nav to page, display content, etc)
//        print(params as? [String: AnyObject] ?? {})
//      }
//      return true
//    }
//
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//      Branch.getInstance().application(app, open: url, options: options)
//      return true
//    }
//
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//      // handler for Push Notifications
//      Branch.getInstance().handlePushNotification(userInfo)
//    }
////    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
////      // handler for Universal Links
////        prin
////      Branch.getInstance().continue(userActivity)
////      return true
////    }
}

