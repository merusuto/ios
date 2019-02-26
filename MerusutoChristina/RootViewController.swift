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

import MBProgressHUD
import Reachability
import RESideMenu
import SDWebImage
import UIKit

class RootViewController: RESideMenu, SDWebImagePrefetcherDelegate {
    var mainTabBarController: UITabBarController?
    var hud: MBProgressHUD!
    var hudTapGesture: UITapGestureRecognizer!

    var isBackgroundDownloading = false
    var isDownloading = false

    override func awakeFromNib() {
        contentViewController = storyboard?.instantiateViewController(withIdentifier: "contentController")
        leftMenuViewController = storyboard?.instantiateViewController(withIdentifier: "menuController")

        mainTabBarController = contentViewController as? UITabBarController

        backgroundImage = UIImage(named: "Stars")

        // 定义SideMenu的样式
        panGestureEnabled = true
        panFromEdge = false

        contentViewShadowEnabled = true
        contentViewShadowColor = .gray
        contentViewShadowOffset = CGSize(width: -10, height: 0)

        let minValue = min(screenWidth, screenHeight)
        let maxValue = max(screenWidth, screenHeight)
        contentViewInPortraitOffsetCenterX = minValue * 0.1
        contentViewInLandscapeOffsetCenterX = maxValue * -0.1
        contentViewScaleValue = 1
        scaleMenuView = false

        // 定义 hud
        hud = MBProgressHUD(view: view)
        hud.isUserInteractionEnabled = true
        hudTapGesture = UITapGestureRecognizer(target: self, action: #selector(RootViewController.hud_clickHandler(sender:)))
        hud.addGestureRecognizer(hudTapGesture)
        view.addSubview(hud!)

        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.background_handler(sender:)), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.background_handler(sender:)), name: UIApplication.didEnterBackgroundNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.loading_handler(sender:)), name: NSNotification.Name(rawValue: ROOT_SHOW_LOADING), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RootViewController.loading_handler(sender:)), name: NSNotification.Name(rawValue: ROOT_HIDE_LOADING), object: nil)
    }

    @objc func loading_handler(sender: NSNotification) {
        print(sender.name)
        if sender.name == NSNotification.Name(rawValue: ROOT_SHOW_LOADING) {
            hud.mode = MBProgressHUDMode.indeterminate
            hud.show(true)
            hud.labelText = "加载中..."
            hud.detailsLabelText = ""

            hudTapGesture.isEnabled = false
            panGestureEnabled = false
        } else if sender.name == NSNotification.Name(rawValue: ROOT_HIDE_LOADING) {
            hudTapGesture.isEnabled = true
            panGestureEnabled = true

            hud.hide(true)
        }
    }

    @objc func background_handler(sender: AnyObject) {
        if sender.name == UIApplication.didEnterBackgroundNotification {
            SDWebImagePrefetcher.shared().cancelPrefetching()
            hud.hide(false)

            isBackgroundDownloading = false
        } else {
            if isDownloading {
                downloadAllResource()
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func hud_clickHandler(sender: UITapGestureRecognizer) {
        isBackgroundDownloading = true
        hud.hide(true)
        hud.isUserInteractionEnabled = false
        panGestureEnabled = true

        SDWebImagePrefetcher.shared().options = [SDWebImageOptions.lowPriority, SDWebImageOptions.progressiveDownload, SDWebImageOptions.continueInBackground]
    }

    func switchToController(index: Int) {
        mainTabBarController!.selectedIndex = index

        hideViewController()
    }

    func downloadAllResource() {
        hideViewController()

        hud.isUserInteractionEnabled = true
        panGestureEnabled = false

        if isBackgroundDownloading {
            hud.show(true)
            hud.mode = MBProgressHUDMode.determinateHorizontalBar
            isBackgroundDownloading = false
            return
        }

        if Reachability.forLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi {
            print("not wifi")
            hud.show(true)
            hud.mode = MBProgressHUDMode.text
            hud.labelText = "请在WIFI下再试"
            hud.hide(true, afterDelay: 1.5)
            return
        }

        // for test
        #if DEBUG
            SDImageCache.sharedImageCache().clearDisk()
            SDImageCache.sharedImageCache().clearMemory()
        #endif

        SDWebImagePrefetcher.shared().options = [.highPriority, .progressiveDownload, .continueInBackground]

        var thumbnails: [URL] = [] // 人物小图
        var originals: [URL] = [] // 人物原图

        hud.show(true)
        hud.labelText = "优君正在统计后宫名单..."
        hud.detailsLabelText = ""
        isDownloading = true

        DataManager.loadJSONWithSuccess(key: "units") { [unowned self] data in
            for (_, each) in data! {
                let item = CharacterItem(data: each)

                let thumbnailUrl: URL = DataManager.getGithubURL("units/thumbnail/\(item.id).png")

                SDWebImageManager.shared().diskImageExists(for: thumbnailUrl) { (isExists: Bool) in
                    if !isExists {
                        thumbnails.append(thumbnailUrl)
                    }
                }

                let originalURL: URL = DataManager.getGithubURL("units/original/\(item.id).png")

                SDWebImageManager.shared().diskImageExists(for: originalURL) { (isExists: Bool) in
                    if !isExists {
                        originals.append(originalURL)
                    }
                }
            }

            DispatchQueue.main.async {
                print("需要下载小图\(thumbnails.count)张")
                self.prefetchImage(text: "下载小图，主人请耐心等待", target: thumbnails) { () -> Void in
                    print("需要下载大图\(originals.count)张")
                    self.prefetchImage(text: "下载原图，主人请耐心等待", target: originals) { () -> Void in

                        self.hud.mode = .text
                        self.hud.labelText = "下载完毕！"
                        self.hud.detailsLabelText = ""

                        self.hud.hide(true, afterDelay: 1.0)

                        self.panGestureEnabled = true
                        self.isBackgroundDownloading = false
                        self.isDownloading = false
                    }
                }
            }
        }
    }

    func prefetchImage(text: String, target: [URL], backFun: (() -> Void)?) {
        hud.mode = .determinateHorizontalBar
        hud.labelText = text
        hud.progress = 0
        hud.detailsLabelText = "0 / \(target.count)"

        SDWebImagePrefetcher.shared().prefetchURLs(target, progress: { [unowned self] bytesLoad, totalBytes in

            if self.isNetworkFail() == true {
                print("网络错误，退出下载")
                SDWebImagePrefetcher.shared().cancelPrefetching()

                self.hud.show(true)
                self.hud.mode = MBProgressHUDMode.text
                self.hud.labelText = "网络错误！"
                self.hud.hide(true, afterDelay: 1.5)

                DispatchQueue.main.async {
                    backFun?()
                }

                return
            }

            SDImageCache.shared().clearMemory()

            self.hud.progress = Float(bytesLoad) / Float(totalBytes)
            self.hud.labelText = text
            self.hud.detailsLabelText = "\(bytesLoad) / \(totalBytes)（点击后台下载）"
        }) { _, _ in
            DispatchQueue.main.async {
                backFun?()
            }
        }
    }

    func clearAllResource() {
        SDWebImagePrefetcher.shared().cancelPrefetching()

        SDImageCache.shared().clearMemory()

        hud.show(true)
        hud.labelText = "优君正在开除后宫..."
        isBackgroundDownloading = false
        isDownloading = false

        hideViewController()

        SDImageCache.shared().clearDisk { [unowned self] in
            DispatchQueue.main.async {
                self.hud.hide(true, afterDelay: 1.5)
            }
        }
    }

    func isNetworkFail() -> Bool {
        return Reachability.forLocalWiFi().currentReachabilityStatus() != NetworkStatus.ReachableViaWiFi
    }
}
