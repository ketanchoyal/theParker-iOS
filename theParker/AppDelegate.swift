//
//  AppDelegate.swift
//  Parker
//
//  Created by Rahul Dhiman on 05/03/18.
//  Copyright © 2018 Rahul Dhiman. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMessaging
import FirebaseCore
import FirebaseInstanceID // token identification by firebase
import UserNotifications //for push notifications
import GoogleSignIn
import IQKeyboardManagerSwift
import Lottie
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate, GIDSignInDelegate{

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        GMSServices.provideAPIKey("AIzaSyBLGhDJUco802MJiog3tf9zd73-NLY0yEI")
        GMSPlacesClient.provideAPIKey("AIzaSyD5iAIQAVNnommi_SbU-z4Eu-8lzbdil7U")
        
        IQKeyboardManager.sharedManager().enable = true
        UIApplication.shared.statusBarStyle = .lightContent
        
        // Override point for customization after application launch.
        //Configuring connection with firebase db and the application
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        //listener for changes to user state
        //validation throw for login sign up
        _ = Auth.auth().addStateDidChangeListener { auth, user in
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            if user != nil {
                let controller = storyboard.instantiateViewController(withIdentifier: "slide") as! SWRevealViewController
                
                //updates the view controller
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()

            } else {
                //menu screen
                let controller = storyboard.instantiateViewController(withIdentifier: "des") as! DescriptionViewController         //updates the view controller ( note: put self to explicitly state the
                self.window?.rootViewController = controller
                self.window?.makeKeyAndVisible()
               
            }
        }
        
        
        
        //User Autharisation for push notifications
        //options state the notification states
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, err) in
            if err != nil {
                //something bad happened
            } else { // if no error continui on
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                DispatchQueue.main.async {
                    //    application.registerForRemoteNotifications()
                    
                }
                
            }
        }
        
        
        return true
    }
    
    func ConnectToFCM(_ choice:Bool) {
        Messaging.messaging().shouldEstablishDirectChannel = choice
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        ConnectToFCM(false)
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ConnectToFCM(true)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        let newToken =  InstanceID.instanceID().token() // returns a string of characters of token firebase recognises
        ConnectToFCM(true)
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            return GIDSignIn.sharedInstance().handle(url,
                                                     sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                     annotation: [:])
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication: sourceApplication,
                                                 annotation: annotation)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        // ...
    }
    


}

