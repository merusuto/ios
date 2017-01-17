//
//  AppDelegate.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/24.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit
import AVOSCloud
import Reachability
import SwiftyJSON
import SDWebImage

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {
        AVOSCloud.setApplicationId("ixeo5jke9wy1vvvl3lr06uqy528y1qtsmmgsiknxdbt2xalg",
                                   clientKey: "hwud6pxjjr8s46s9vuix0o8mk0b5l8isvofomjwb5prqyyjg")

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
        print(SDWebImageManager.shared().imageCache == SDImageCache.shared())
        print(SDWebImageManager.shared().imageCache === SDImageCache.shared())
    }
}
