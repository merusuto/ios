//
//  SwiftPerfix.swift
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/5.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import Foundation
import UIKit
import YYKit

var screenSize: CGSize {
    return UIScreen.main.bounds.size
}

var screenWidth: CGFloat {
    return screenSize.width
}

var screenHeight: CGFloat {
    return screenSize.height
}

func getStringWidth(value: String, font: UIFont) -> CGFloat {
    let temp: NSString = NSString(string: value)

    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 1)
    let bounds = temp.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

    return bounds.width
}

var isPortrait: Bool {
    return screenWidth < screenHeight
}

var iPhoneX: Bool {
    let height = max(screenWidth, screenHeight)
    return height == 812 || height == 896
}

public let IMAGE_SCALE_SCROLLVIEW_ZOOMING = "image.scale.scrollview.zooming"
public let ROOT_SHOW_LOADING = "root.show.loading"
public let ROOT_HIDE_LOADING = "root.hide.loading"
public let PATCH_COMPLETE = "patch.complete"

func postShowLoading() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ROOT_SHOW_LOADING), object: nil)
}

func postHideLoading() {
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ROOT_HIDE_LOADING), object: nil)
}
