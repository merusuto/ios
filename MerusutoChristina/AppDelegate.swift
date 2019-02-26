//
//  AppDelegate.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/24.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import Reachability
import SDWebImage
import SwiftyJSON
import UIKit
import Bugly

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        Bugly.start(withAppId: "faba2b868f")
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        print("内存警告，清除图片缓存")
        SDWebImageManager.shared().imageCache?.clearMemory()
        SDImageCache.shared().clearMemory()
    }
}
