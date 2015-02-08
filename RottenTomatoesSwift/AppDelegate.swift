//
//  AppDelegate.swift
//  RottenTomatoesSwift
//
//  Created by Kristen on 2/2/15.
//  Copyright (c) 2015 Kristen Sundquist. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        // Tab Bar
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = UIColor(red: 199/255.0, green: 217/255.0, blue: 98/255.0, alpha: 1.0)
        tabBarController.tabBar.barTintColor = UIColor(red: 46/255.0, green: 0/255.0, blue: 49/255.0, alpha: 1.0)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let dvdNavigationController = storyboard.instantiateViewControllerWithIdentifier("MyNavigationController") as UINavigationController
        let dvdViewController = dvdNavigationController.topViewController as ViewController
        dvdViewController.rottenTomatoesURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=50&country=us"
        dvdNavigationController.navigationBar.topItem?.title = "DVD"
        dvdNavigationController.tabBarItem.title = "DVD"
        dvdNavigationController.tabBarItem.image = UIImage(named: "dvd-icon")
        
        let boxOfficeNavigationController = storyboard.instantiateViewControllerWithIdentifier("MyNavigationController") as UINavigationController
        let boxOfficeViewController = boxOfficeNavigationController.topViewController as ViewController
        boxOfficeViewController.rottenTomatoesURL = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9&limit=50&country=us"
        boxOfficeNavigationController.navigationBar.topItem?.title = "Theaters"
        boxOfficeNavigationController.tabBarItem.title = "Theaters"
        boxOfficeNavigationController.tabBarItem.image = UIImage(named: "box-office-icon")
        
        tabBarController.viewControllers = [dvdNavigationController, boxOfficeNavigationController]
        
        window?.rootViewController = tabBarController
        window?.backgroundColor = UIColor(red: 241/255.0, green: 241/255.0, blue: 241/255.0, alpha: 1.0)
        window?.makeKeyAndVisible()
        
        return true
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
    }


}

