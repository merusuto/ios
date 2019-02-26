//
//  ImageViewer.swfit
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/12.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import MBProgressHUD
import SDWebImage
import UIKit

class ImageViewer: UIScrollView, UIScrollViewDelegate {
    var hud: MBProgressHUD!

    var isZoomImage: Bool = false

    var minZoomScale: CGFloat!

    var imageView: UIImageView!

    var imageUrl: URL! {
        didSet {
            print("imageUrl didSet")
            self.hud.show(true)

            self.imageView.sd_setImage(with: imageUrl,
                                       placeholderImage: nil,
                                       options: [.progressiveDownload, .retryFailed],
                                       progress: { (receivedSize: Int, totalSize: Int, _) -> Void in

                                           // 计算下载进度
                                           // print("id:\(self.item.id) \(receivedSize)/\(totalSize)")
                                           self.hud.progress = (Float(receivedSize) / Float(totalSize))

                                       },
                                       completed: { (image, error, _, _) -> Void in

                                           print("\(String(describing: image)) \(String(describing: self.imageUrl))")
                                           if error != nil || image == nil {
                                               self.hud.labelText = "加载失败..."
                                               print("网络错误 \(String(describing: error))")
                                               return
                                           }

                                           self.imageView.image = image
                                           self.imageView.frame = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)

                                           self.calculateImageViewFrame()

                                           self.hud.hide(true)

                                           UIView.animate(withDuration: 0.25) { () -> Void in
                                               self.imageView.alpha = 1
                                           }
            })
        }
    }

    required init? (coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.delegate = self

        self.imageView = UIImageView()
        self.imageView.contentMode = .scaleAspectFit
        self.addSubview(self.imageView)

        self.hud = MBProgressHUD(view: self)
        self.hud.labelText = "立绘加载中..."
        self.hud.mode = .determinate
        self.hud.backgroundColor = .clear
        self.hud.color = UIColor.clear
        self.addSubview(self.hud)
        self.hud.hide(false)
    }

    func calculateImageViewFrame() {
        if self.imageView.image == nil {
            return
        }

        let frameSize = self.frame.size
        let contentSize = imageView.image!.size
        let scaleWidth = frameSize.width / contentSize.width
        let scaleHeight = frameSize.height / contentSize.height
        self.minZoomScale = min(scaleWidth, scaleHeight)

        self.minimumZoomScale = minZoomScale
        self.zoomScale = minZoomScale

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: self)

        centerScrollViewContents()
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        self.isZoomImage = false

        self.bounces = true

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: self)
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.centerScrollViewContents()
    }

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        self.isZoomImage = self.zoomScale != self.minimumZoomScale

        self.bounces = isZoomImage

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: self)
    }

    func centerScrollViewContents() {
        let boundsSize = self.frame.size
        var contentsFrame = imageView.frame

        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0
        }

        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0
        }

        self.imageView.frame = contentsFrame
    }
}
