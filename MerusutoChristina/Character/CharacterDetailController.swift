//
//  CharacterDetailController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/27.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import UIKit
import SDWebImage
import MBProgressHUD

class CharacterDetailController: UIViewController, UIScrollViewDelegate {

	var scrollView: UIScrollView!
	var contentView: UIView!

	var imageViewer: ImageViewer!
	var propertyViewer: PropertyDetailView!

	var pageController: UIPageControl!
	var pageBeforeRotate: Int!

	var item: CharacterItem! {
		didSet {

			print("character didSet")

			let _ = self.view

			propertyViewer.item = item

			imageViewer.imageUrl = getItemUrl()

			setDetailFontSize()
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()

//        AVAnalytics.event("Open", label: "0 \(item.id)")

		scrollView = UIScrollView(frame: self.view.bounds)
		scrollView.backgroundColor = UIColor(red: 0.139, green: 0.137, blue: 0.142, alpha: 0.9)
		scrollView.isPagingEnabled = true
		scrollView.delegate = self
		scrollView.showsVerticalScrollIndicator = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.bounces = false
		self.view.addSubview(scrollView)

		contentView = UIView(frame: self.view.bounds)
		scrollView.addSubview(contentView)

		imageViewer = ImageViewer(frame: self.view.bounds)
		contentView.addSubview(imageViewer)

		propertyViewer = getPropertyDetailView()
		contentView.addSubview(propertyViewer)

		pageController = UIPageControl()
		pageController.numberOfPages = 2
		pageController.isUserInteractionEnabled = false
		self.view.addSubview(pageController)

		setConstraints()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(CharacterDetailController.tap_handler(gesture:)))
		self.view.addGestureRecognizer(gesture)

        NotificationCenter.default.addObserver(self, selector:#selector(CharacterDetailController.imageViewer_handler(note:)), name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: nil)
	}

	func getPropertyDetailView() -> PropertyDetailView {
		return CharacterPropertyView(frame: self.view.bounds)
	}

	func getItemUrl() -> URL {
		return DataManager.getGithubURL("units/original/\(item.id).png")
	}

	func setConstraints() {
		scrollView.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.view)
			make.right.equalTo(self.view)
			make.top.equalTo(self.view)
			make.bottom.equalTo(self.view)
		}

		contentView.snp.updateConstraints {[unowned self] (make) -> Void in
			make.edges.equalTo(self.scrollView)
			make.height.equalTo(self.scrollView)
			make.width.equalTo(self.scrollView).multipliedBy(2)
		}

		imageViewer.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.contentView.snp.left)
			make.top.equalTo(self.contentView.snp.top)
			make.bottom.equalTo(self.contentView.snp.bottom)
			make.width.equalTo(self.contentView).multipliedBy(0.5)
		}

		propertyViewer.snp.updateConstraints {[unowned self] (make) -> Void in
			make.left.equalTo(self.imageViewer.snp.right)
			make.top.equalTo(self.imageViewer.snp.top).offset(20)
			make.bottom.equalTo(self.imageViewer.snp.bottom).offset(-20)
			make.width.equalTo(self.imageViewer.snp.width)
		}

		pageController.snp.makeConstraints { [unowned self](make) -> Void in
			make.centerX.equalTo(self.view.snp.centerX)
			make.bottom.equalTo(self.view.snp.bottom).offset(0)
			make.width.equalTo(80)
			make.height.equalTo(20)
		}
	}

    @objc func imageViewer_handler(note: NSNotification) {
		self.scrollView.isScrollEnabled = !imageViewer.isZoomImage
	}

	deinit {
		print("unit item dealloc")

		NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: nil)
	}

    @objc func tap_handler(gesture: UITapGestureRecognizer) {

		self.dismiss(animated: true, completion: nil)
	}

	override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {

		pageBeforeRotate = pageController.currentPage

		UIView.animate(withDuration: 0.15, animations: {
			self.imageViewer.alpha = 0
			self.propertyViewer.alpha = 0
			self.pageController.alpha = 0
		})
	}

	func setDetailFontSize() {

		let screenWidth: CGFloat = getScreenWidth()
		let screenHeight: CGFloat = getScreenHeight()

		// 不用UIDevice.currentDevice().orientation去判断，是因为会有isFalt的情况出现
		let isPortrait: Bool = screenWidth < screenHeight

		let fontSize: CGFloat = isPortrait ? screenWidth / 414.0 * 18.0 : screenWidth / 736 * 17.0

		self.propertyViewer.setFontSize(value: fontSize)
	}

	override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {

		self.pageController.currentPage = self.pageBeforeRotate
        self.scrollView.setContentOffset(CGPoint(x: self.scrollView.frame.width * CGFloat(self.pageBeforeRotate), y: 0), animated: false)

        UIView.animate(withDuration: 0.25){
            self.imageViewer.alpha = 1
            self.propertyViewer.alpha = 1
            self.pageController.alpha = 1
        }

		imageViewer.calculateImageViewFrame()
		setDetailFontSize()
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		imageViewer.calculateImageViewFrame()
	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		pageController.currentPage = Int((scrollView.contentOffset.x + scrollView.frame.width / 2) / scrollView.frame.width)
	}
}
