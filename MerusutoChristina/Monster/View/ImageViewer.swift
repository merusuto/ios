//
//  ImageViewer.swfit
//  MerusutoChristina
//
//  Created by 莫锹文 on 16/3/12.
//  Copyright © 2016年 bbtfr. All rights reserved.
//

import UIKit
import MBProgressHUD
import SDWebImage

class ImageViewer: UIScrollView, UIScrollViewDelegate {

    var hud: MBProgressHUD!

    var isZoomImage: Bool = false

    var minZoomScale: CGFloat!

    var imageView: UIImageView!

    var imageUrl: URL! {
        didSet {

            print("imageUrl didSet")
            self.hud.show(true)
            

            self.imageView.sd_setImage(with: imageUrl as URL!, placeholderImage: nil, options: [SDWebImageOptions.progressiveDownload, SDWebImageOptions.retryFailed], progress: {
                (receivedSize: Int, totalSize: Int, _) -> Void in

                // 计算下载进度
                // print("id:\(self.item.id) \(receivedSize)/\(totalSize)")
                self.hud.progress = (Float(receivedSize) / Float(totalSize))

            }, completed: {

                (image: UIImage?, error: Error?, type, url: URL?) -> Void in

                print("\(#function) \(image) \(self.imageUrl)")
                if error != nil || image == nil {
                    self.hud.labelText = "加载失败..."
                    print("网络错误 \(error)")
                    return
                }

                self.imageView.image = image
                //				self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height)
                self.imageView.frame = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)

                self.calculateImageViewFrame()

                self.hud.hide(true)

                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.imageView.alpha = 1
                })
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
        imageView.contentMode = UIViewContentMode.scaleAspectFit
        self.addSubview(imageView)

        self.hud = MBProgressHUD(view: self)
        self.hud.labelText = "立绘加载中..."
        self.hud.mode = MBProgressHUDMode.determinate
        self.hud.backgroundColor = UIColor.clear
        self.hud.color = UIColor.clear
        self.addSubview(hud)
        self.hud.hide(false)
    }

    func calculateImageViewFrame() {
        if imageView.image == nil {
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
        
        isZoomImage = false

        self.bounces = true

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: IMAGE_SCALE_SCROLLVIEW_ZOOMING), object: self)
    }

    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        centerScrollViewContents()
    }
    

    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {

        isZoomImage = self.zoomScale != self.minimumZoomScale

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
