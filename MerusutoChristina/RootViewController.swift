//
//  RootViewController.swift
//  MerusutoChristina
//
//
//  主容器，处理菜单ViewController和内容ViewController
//
//  Created by 莫锹文 on 16/2/22.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import RESideMenu
import SDWebImage
import MBProgressHUD
import Reachability

class RootViewController: RESideMenu, SDWebImagePrefetcherDelegate {

    var mainTabBarController: UITabBarController?
    var hud: MBProgressHUD!
    var hudTapGesture: UITapGestureRecognizer!

    var isBackgroundDownloading = false
    var isDownloading = false
    typealias MyBlock = () -> Void

    override func awakeFromNib() {
        self.contentViewController = self.storyboard?.instantiateViewController(withIdentifier: "contentController")
        self.leftMenuViewController = self.storyboard?.instantiateViewController(withIdentifier: "menuController")

        self.mainTabBarController = self.contentViewController as? UITabBarController

        self.backgroundImage = UIImage(named: "Stars")

        // 定义SideMenu的样式
        self.panGestureEnabled = true
        self.panFromEdge = false

        self.contentViewShadowEnabled = true
        self.contentViewShadowColor = UIColor.gray
        self.contentViewShadowOffset = CGSize(width: -10, height: 0)

        let minValue = min(getScreenWidth(), getScreenHeight())
        let maxValue = max(getScreenWidth(), getScreenHeight())
        self.contentViewInPortraitOffsetCenterX = minValue * 0.1
        self.contentViewInLandscapeOffsetCenterX = maxValue * -0.1
        self.contentViewScaleValue = 1
        self.scaleMenuView = false

        // 定义 hud
        hud = MBProgressHUD(view: self.view)
        hud.isUserInteractionEnabled = true
        self.hudTapGesture = UITapGestureRecognizer(target: self, action: #selector(RootViewController.hud_clickHandler(sender:)))
        hud.addGestureRecognizer(hudTapGesture)
        self.view.addSubview(hud!)

        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.background_handler(sender:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.background_handler(sender:)), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.loading_handler(sender:)), name: NSNotification.Name(rawValue: ROOT_SHOW_LOADING), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.loading_handler(sender:)), name: NSNotification.Name(rawValue: ROOT_HIDE_LOADING), object: nil)

    }

    func loading_handler(sender: NSNotification) {
        print(sender.name)
        if sender.name == NSNotification.Name(rawValue: ROOT_SHOW_LOADING) {
            hud.mode = MBProgressHUDMode.indeterminate
            hud.show(true)
            hud.labelText = "加载中..."
            hud.detailsLabelText = ""

            hudTapGesture.isEnabled = false
            self.panGestureEnabled = false
        } else if sender.name == NSNotification.Name(rawValue: ROOT_HIDE_LOADING) {

            hudTapGesture.isEnabled = true
            self.panGestureEnabled = true

            hud.hide(true)
        }
    }

    func background_handler(sender: AnyObject) {

        if sender.name == NSNotification.Name.UIApplicationDidEnterBackground {
            SDWebImagePrefetcher.shared().cancelPrefetching()
            self.hud.hide(false)

            self.isBackgroundDownloading = false
        } else {
            if self.isDownloading {
                downloadAllResource()
            }
        }
    }

    deinit {

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }

    func hud_clickHandler(sender: UITapGestureRecognizer) {
        self.isBackgroundDownloading = true
        self.hud.hide(true)
        self.hud.isUserInteractionEnabled = false
        self.panGestureEnabled = true

        SDWebImagePrefetcher.shared().options = [SDWebImageOptions.lowPriority, SDWebImageOptions.progressiveDownload, SDWebImageOptions.continueInBackground]
    }

    func switchToController(index: Int) {
        self.mainTabBarController!.selectedIndex = index

        self.hideViewController()
    }

    func downloadAllResource() {

        self.hideViewController()

        self.hud.isUserInteractionEnabled = true
        self.panGestureEnabled = false

        if self.isBackgroundDownloading {
            self.hud.show(true)
            self.hud.mode = MBProgressHUDMode.determinateHorizontalBar
            self.isBackgroundDownloading = false
            return
        }

        if Reachability.forLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi {
            print("not wifi")
            self.hud.show(true)
            self.hud.mode = MBProgressHUDMode.text
            self.hud.labelText = "请在WIFI下再试"
            self.hud.hide(true, afterDelay: 1.5)
            return
        }

        // for test
        #if DEBUG
            SDImageCache.sharedImageCache().clearDisk()
            SDImageCache.sharedImageCache().clearMemory()
        #endif

        SDWebImagePrefetcher.shared().options = [SDWebImageOptions.highPriority, SDWebImageOptions.progressiveDownload, SDWebImageOptions.continueInBackground]

        var thumbnails: Array<URL> = Array() // 人物小图
        var originals: Array<URL> = Array() // 人物原图

        self.hud.show(true)
        self.hud.labelText = "优君正在统计后宫名单..."
        self.hud.detailsLabelText = ""
        self.isDownloading = true

        DataManager.loadJSONWithSuccess(key: "units", success: { (data) -> Void in
            for (_, each) in data! {
                let item = CharacterItem(data: each)

                let thumbnailUrl: URL = DataManager.getGithubURL("units/thumbnail/\(item.id).png")

                SDWebImageManager.shared().diskImageExists(for: thumbnailUrl, completion: { (isExists:Bool) in
                    if isExists {
                        thumbnails.append(thumbnailUrl)
                    }
                })

                let originalURL: URL = DataManager.getGithubURL("units/original/\(item.id).png")
                
                SDWebImageManager.shared().diskImageExists(for: originalURL, completion: { (isExists:Bool) in
                    if isExists {
                        originals.append(originalURL)
                    }
                })
            }

            DispatchQueue.main.async {
                self.prefetchImage(text: "下载小图，主人请耐心等待", target: thumbnails, backFun: { () -> Void in

                    self.prefetchImage(text: "下载原图，主人请耐心等待", target: originals, backFun: { () -> Void in

                        self.hud.mode = MBProgressHUDMode.text
                        self.hud.labelText = "下载完毕！"
                        self.hud.detailsLabelText = ""

                        self.hud.hide(true, afterDelay: 1.0)

                        self.panGestureEnabled = true
                        self.isBackgroundDownloading = false
                        self.isDownloading = false
                    })
                })

            }
        })
    }

    func prefetchImage(text: String, target: Array<URL>, backFun: MyBlock?) {

        self.hud.mode = MBProgressHUDMode.determinateHorizontalBar
        self.hud.labelText = text
        self.hud.progress = 0
        self.hud.detailsLabelText = "0 / \(target.count)"

        SDWebImagePrefetcher.shared().prefetchURLs(target, progress: { (bytesLoad: UInt, totalBytes: UInt) -> Void in

            if self.isNetworkFail() == true {

                print("网络错误，退出下载")
                SDWebImagePrefetcher.shared().cancelPrefetching()

                self.hud.show(true)
                self.hud.mode = MBProgressHUDMode.text
                self.hud.labelText = "网络错误！"
                self.hud.hide(true, afterDelay: 1.5)

                if backFun != nil {
                    DispatchQueue.main.async {
                        backFun!()
                    }
                }

                return
            }

            SDImageCache.shared().clearMemory();

            
            self.hud.progress = Float(bytesLoad) / Float(totalBytes)
            self.hud.labelText = text
            self.hud.detailsLabelText = "\(bytesLoad) / \(totalBytes)（点击后台下载）"
        }) { (value1: UInt, value2: UInt) -> Void in
            if backFun != nil {
                DispatchQueue.main.async {
                    backFun!()
                }
            }
        }
    }

    func clearAllResource() {
        SDWebImagePrefetcher.shared().cancelPrefetching()

        print(Thread.current)

        SDImageCache.shared().clearMemory()

        self.hud.show(true)
        self.hud.labelText = "优君正在开除后宫..."
        self.isBackgroundDownloading = false
        self.isDownloading = false

        self.hideViewController()

        SDImageCache.shared().clearDisk { () -> Void in
            DispatchQueue.main.async {
                self.hud.hide(true, afterDelay: 1.5)
            }
        }
    }

    func isNetworkFail() -> Bool {
        return Reachability.forLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi
    }
}
