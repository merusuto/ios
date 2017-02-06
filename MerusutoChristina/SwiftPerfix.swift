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

func getScreen() -> CGSize {
	return UIScreen.main.bounds.size;
}

func getScreenWidth() -> CGFloat {
	return getScreen().width
}

func getScreenHeight() -> CGFloat {
	return getScreen().height
}

func getStringWidth(value: String, font: UIFont) -> CGFloat {

	let temp: NSString = NSString(string: value)

    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 1)
	let bounds = temp.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)

	return bounds.width
}

//		 不用UIDevice.currentDevice().orientation去判断，是因为会有isFalt的情况出现
func getIsPortrait() -> Bool {
	let screenWidth: CGFloat = getScreenWidth()
	let screenHeight: CGFloat = getScreenHeight()

	return screenWidth < screenHeight
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
