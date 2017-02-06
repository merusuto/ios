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
import JSPatch
import JSPatchPlatform

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]? = nil) -> Bool {

        JSPatch.setupCallback { (type: JPCallbackType, info: [AnyHashable: Any]?, error: Error?) in
            print("jspatch callback")
            print(type)
            
            if error != nil {
                print(error!)
                return
            }

            
            switch type {
            case .condition:
                print("条件下载")

            case .gray:
                print("灰度下载")

            case .runScript:
                print("执行脚本")
                for value in info!
                {
                    print(value)
                }
                
                if let value = info?["scriptData"] {
                    let string:String = String.init(data: value as! Data, encoding: String.Encoding.utf8)!
                    print("新脚本内容：\n", string)
                }
                NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: PATCH_COMPLETE), object: nil)
                
            case .unknow:
                print("未知")
                
            case .update:
                print("更新脚本")
                
            case .updateDone:
                print("更新完成")
                
            case .updateFail:
                print("更新失败")

            }
            
            
        }

        JSPatch.start(withAppKey: "daa229735e62bcf1")
//        JSPatch.setupDevelopment()
        JSPatch.sync()

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
