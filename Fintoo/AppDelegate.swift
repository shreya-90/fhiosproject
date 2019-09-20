
//
//  AppDelegate.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import DropDown
import Fabric
import Crashlytics
import Mixpanel
import UserNotifications
import Firebase
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate {

    var window: UIWindow?
    var defaults: UserDefaults?
    let googleMapsApiKey = "AIzaSyAbsZQN1VSz6G8AzM5tS7ntd7iB4T5SgWk"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Use Firebase library to configure APIs
        FirebaseApp.configure()
        // Override point for customization after application launch.
       // Thread.sleep(forTimeInterval: 5.0)
        Mixpanel.initialize(token: "adf0536f6c3c3886df7a031e5102f2ab")
        //IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.shared.enable = true
        DropDown.startListeningToKeyboard()
        let notificationOption = launchOptions?[.remoteNotification]
        if let notification = notificationOption as? [AnyHashable: Any]{
            if (UserDefaults.standard.value(forKey: "userLogIn") as? Bool)  == true {
               
                
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                    let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                    let navController = UINavigationController(rootViewController: viewController)
                    viewController.id = "kill" ///pass data to your viewcontroller
                    viewController.notification_kill = notification
                    self.window?.rootViewController = navController
                    self.window?.makeKeyAndVisible()
                
                //}
            }else {
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
               // let navController = UINavigationController(rootViewController: viewController)
                viewController.id = "kill" ///pass data to your viewcontroller
                viewController.notification_kill = notification
                self.window?.rootViewController = viewController
                self.window?.makeKeyAndVisible()
            }
        }else {
            if (UserDefaults.standard.value(forKey: "userLogIn") as? Bool)  == true {
                print("Userdefaults are set")
                self.window = UIWindow(frame: UIScreen.main.bounds)
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                
                let viewController = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navController = UINavigationController(rootViewController: viewController)
                self.window?.rootViewController = navController
                self.window?.makeKeyAndVisible()
            }else{
                print("User default are not set")
            }
        }
        
        GMSServices.provideAPIKey(googleMapsApiKey)
        Fabric.with([Crashlytics.self])
        logUser()
        //NSSetUncaughtExceptionHandler(exceptionHandler)
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        Messaging.messaging().delegate = self
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
        
        application.registerForRemoteNotifications()
        

        
        return true
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        //print("2")
        Messaging.messaging().unsubscribe(fromTopic : "Fintoo")
        Messaging.messaging().subscribe(toTopic : "Fintooios")
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
     
        if (UserDefaults.standard.value(forKey: "userLogIn") as? Bool)  == true {
            NotificationCenter.default.post(name: Notification.Name("notificationName"),
                                            object: nil,userInfo:userInfo)
        }else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let viewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            // let navController = UINavigationController(rootViewController: viewController)
            viewController.id = "kill" ///pass data to your viewcontroller
            viewController.notification_kill = userInfo
            self.window?.rootViewController = viewController
            self.window?.makeKeyAndVisible()
        }
            print(userInfo)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler([.alert, .badge, .sound])
    }
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        let userid = UserDefaults.standard.value(forKey: "userid") as? String
        let email = UserDefaults.standard.value(forKey: "Email") as? String
        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        
        if (UserDefaults.standard.value(forKey: "userid") != nil){
            Crashlytics.sharedInstance().setUserEmail(email)
            Crashlytics.sharedInstance().setUserIdentifier(userid)
            Crashlytics.sharedInstance().setUserName(phone)
        }
    }
    
    func exceptionHandler(exception: NSException) {
        print("*** UNHANDLED EXCEPTION ***")
        print(exception)
        print("CALL STACK:")
        print(exception.callStackSymbols.joined(separator: "\n"))
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        //  UIAlertView *alertView;
        //  NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        print("URL scheme:\(url.scheme ?? "")")
        print("URL query: \(url.query ?? "")")
        
//        FirstViewController.bdFV.bdvc.pushPGStatus()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print(flag)
        print(all_flag)
         if (UserDefaults.standard.value(forKey: "userLogIn") as? Bool)  == true {
         if all_flag != "0" {
            print(flag)
            let pan_no =  UserDefaults.standard.value(forKey: "pan") as? String
            UserDefaults.standard.setValue(pan_no, forKey: "pan")
            if flag != "0" {
              UserDefaults.standard.setValue(flag, forKey: "userid")
            }else {
                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                UserDefaults.standard.setValue(p_userid, forKey: "userid")
            }
           // all_flag = "1"
        }else {
            let pan_no =  UserDefaults.standard.value(forKey: "parent_pan") as! String
            UserDefaults.standard.setValue(pan_no, forKey: "pan")
            let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
            UserDefaults.standard.setValue(p_userid, forKey: "userid")
            //all_flag = "1"
        }
         }else{
            print("not set")
        }
        
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print(flag)
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
       
    }


}

