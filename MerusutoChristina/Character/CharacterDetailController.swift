//
//  CharacterDetailController.swift
//  MerusutoChristina
//
//  Created by AMBER on 15/2/27.
//  Copyright (c) 2015年 bbtfr. All rights reserved.
//

import MBProgressHUD
import SDWebImage
import UIKit

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

            _ = self.view

            propertyViewer.item = item

            imageViewer.imageUrl = getItemUrl()

            setDetailFontSize()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        AVAnalytics.event("Open", label: "0 \(item.id)")

        scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor(red: 0.139, green: 0.137, blue: 0.142, alpha: 0.9)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        view.addSubview(scrollView)

        contentView = UIView(frame: view.bounds)
        scrollView.addSubview(contentView)

        imageViewer = ImageViewer(frame: view.bounds)
        contentView.addSubview(imageViewer)

        propertyViewer = getPropertyDetailView()
        contentView.addSubview(propertyViewer)

        pageController = UIPageControl()
        pageController.numberOfPages = 2
        pageController.isUserInteractionEnabled = false
        view.addSubview(pageController)

        setConstraints()

        let gesture = UITapGestureRecognizer(target: self, action: #selector(CharacterDetailController.tap_handler(gesture:)))
        view.addGestureRecognizer(gesture)

        NotificationCenter.default.addObserver(self, selector: #selector(CharacterDetailController.imageViewer_handler(note:)), name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: nil)
    }

    func getPropertyDetailView() -> PropertyDetailView {
        return CharacterPropertyView(frame: view.bounds)
    }

    func getItemUrl() -> URL {
        return DataManager.getGithubURL("units/original/\(item.id).png")
    }

    func setConstraints() {
        scrollView.snp.updateConstraints {
            $0.left.equalTo(self.view)
            $0.right.equalTo(self.view)
            $0.top.equalTo(self.view)
            $0.bottom.equalTo(self.view)
        }

        contentView.snp.updateConstraints {
            $0.edges.equalTo(self.scrollView)
            $0.height.equalTo(self.scrollView)
            $0.width.equalTo(self.scrollView).multipliedBy(2)
        }

        imageViewer.snp.updateConstraints {
            $0.left.equalTo(self.contentView.snp.left)
            $0.top.equalTo(self.contentView.snp.top)
            $0.bottom.equalTo(self.contentView.snp.bottom)
            $0.width.equalTo(self.contentView).multipliedBy(0.5)
        }

        propertyViewer.snp.updateConstraints {
            $0.left.equalTo(self.imageViewer.snp.right)
            $0.top.equalTo(self.topLayoutGuide.snp.bottom)
            $0.bottom.equalTo(self.bottomLayoutGuide.snp.top)
            $0.width.equalTo(self.imageViewer.snp.width)
        }

        pageController.snp.makeConstraints {
            $0.centerX.equalTo(self.view.snp.centerX)
            $0.bottom.equalTo(self.view.snp.bottom).offset(0)
            $0.width.equalTo(80)
            $0.height.equalTo(20)
        }
    }

    @objc func imageViewer_handler(note: NSNotification) {
        scrollView.isScrollEnabled = !imageViewer.isZoomImage
    }

    deinit {
        print("unit item dealloc")

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: nil)
    }

    @objc func tap_handler(gesture: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }

    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        pageBeforeRotate = pageController.currentPage

        UIView.animate(withDuration: 0.15) {
            self.imageViewer.alpha = 0
            self.propertyViewer.alpha = 0
            self.pageController.alpha = 0
        }
    }

    func setDetailFontSize() {
        let fontSize: CGFloat = isPortrait ? screenWidth / 414.0 * 18.0 : screenWidth / 736 * 17.0

        propertyViewer.setFontSize(value: fontSize)
    }

    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        pageController.currentPage = pageBeforeRotate
        scrollView.setContentOffset(CGPoint(x: scrollView.frame.width * CGFloat(pageBeforeRotate), y: 0), animated: false)

        UIView.animate(withDuration: 0.25) {
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
