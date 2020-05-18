//
//  AppDelegate.swift
//  Pawsome
//
//  Created by Marentilo on 30.04.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit
import CoreData

protocol AppDelegateProtocol {
    var context : AppContext! { get }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppDelegateProtocol {
    static let shared = UIApplication.shared.delegate as! AppDelegateProtocol
    var window: UIWindow?
    var context : AppContext!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        context = AppContext.context()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        let vc = RootTabBarViewController()
        window?.rootViewController = vc
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        AppSnapshot.removeImagesFromDisk()
    }
}

