//
//  AppDelegate.swift
//  MLH-Braintree
//
//  Created by Jessie Serrino on 4/11/15.
//  Copyright (c) 2015 Jessie Serrino. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var manager: BeaconManager?
    var locationManager: CLLocationManager?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        application.registerUserNotificationSettings(UIUserNotificationSettings (forTypes: UIUserNotificationType.Alert, categories: nil))
        
        application.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        locationManager = CLLocationManager()
        manager = BeaconManager()
        locationManager?.startUpdatingLocation()
        manager?.start()
        
        return true
    }
    
    func application(handleClosestBeaconChange beacon: CLBeacon) {
        let center = NSNotificationCenter.defaultCenter()
        let notification = NSNotification(name: "Closest Beacon Center", object: self, userInfo: ["Beacon": beacon])
        center.postNotification(notification)
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}

