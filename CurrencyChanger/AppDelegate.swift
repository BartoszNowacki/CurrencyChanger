//
//  AppDelegate.swift
//  CurrencyChanger
//
//  Created by Bartosz Nowacki on 08/04/2019.
//  Copyright © 2019 Bartosz Nowacki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
         window = UIWindow(frame: UIScreen.main.bounds)
        
        window!.rootViewController = getView()
        window!.makeKeyAndVisible()
        return true
    }
    
    func getView() -> MainViewController {
        let homeViewController = MainViewController()
        homeViewController.view.backgroundColor = UIColor.white
        return homeViewController
    }
}
