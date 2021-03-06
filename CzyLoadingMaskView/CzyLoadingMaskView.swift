//
//  CzyLoadingMaskView.swift
//  CzyLoadingMaskView
//
//  Created by macOfEthan on 17/7/24.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

import Foundation
import UIKit

public enum czyRotationStyle:Int{
    
    case system
    
    case custom
}

var rotaionImageView:UIImageView?

var rotationImageWidth:CGFloat? = 30
var rotationImageHeight:CGFloat? = 30

var activityView:UIActivityIndicatorView?

public extension UIImageView{
    
    
    
    
    //内部不能直接添加成员变量（extensions may not contain stored...） 写到外边
    
    //typedef void(^SDWebImageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL)
    //typedef void(^SDExternalCompletionBlock)(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL)
    
    // MARK: - 自定义旋转视图
    ///
    /// - Parameters:
    ///   - url: url
    ///   - image: 默认图片
    ///   - style: 样式：系统 自定义
    public func createCzyImage(imageUrl url:String?, placeHolderImage image:UIImage?, rotationStyle style:czyRotationStyle) -> Void {
        
        //添加样式
        if style == .system {
            
            if activityView != nil {
                return
            }
            
            //系统
            activityView = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
            activityView?.transform = CGAffineTransform.init(scaleX: 2.0, y: 2.0)
            activityView?.center = CGPoint.init(x: self.bounds.size.width/2, y: self.bounds.size.height/2)
            activityView?.startAnimating()
            self.addSubview(activityView!)
            
        }else if(style == .custom){
            
            if rotaionImageView != nil {
                return
            }
            
            //自定义
            self.addRotationImageView(CGRect.init(x: self.bounds.size.width/2-rotationImageWidth!/2,
                                                  y: self.bounds.size.height/2-rotationImageHeight!/2,
                                                  width: rotationImageWidth!,
                                                  height: rotationImageHeight!))
            
        }
       
        //请求
        self.sd_setImage(with: URL.init(string: url!),
                         placeholderImage: image,
                         options: SDWebImageOptions.allowInvalidSSLCertificates,
                         progress: {(_ receivedSize:NSInteger?, _ expectedSize:NSInteger?, _  targetURL:URL?) ->Void in
                            
            //图片下载完成后 不再走progress回调
            print("receivedSize = \(receivedSize) \n expectedSize = \(expectedSize) \n targetURL = \(targetURL?.absoluteString)")
                            
                            
        }, completed: {(image:UIImage?,
            error:Error?,
            cacheType:SDImageCacheType?,
            imageURL:URL?) ->Void in
            
            print("completion")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5, execute: {() ->Void in
            
                //移除
                if((activityView) != nil){
                    activityView?.stopAnimating()
                    activityView?.removeFromSuperview()
                    activityView = nil
                }
                
                if((rotaionImageView) != nil){
                    self.removeRotationImageView()
                }
            })
        })
    }
    
    //开始旋转
    func addRotationImageView(_ rect:CGRect) -> Void {
        
        rotaionImageView = UIImageView.init(frame: rect)
        rotaionImageView?.image = #imageLiteral(resourceName: "rotationImage")
        rotaionImageView?.layer.add(self.addImageRotation(), forKey: "rotation")
        rotaionImageView?.backgroundColor = UIColor.red
        self.addSubview(rotaionImageView!)
    }
    
    //结束旋转 移除
    func removeRotationImageView() -> Void {
        
        rotaionImageView?.layer.removeAnimation(forKey: "rotation")
        rotaionImageView?.removeFromSuperview()
        rotaionImageView = nil
    }
    
    //旋转动画
    func addImageRotation() -> CAKeyframeAnimation {
        
        let rotationAnimation:CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform.rotation.z")
        rotationAnimation.values = [0, M_PI_2, M_PI, M_PI_2*3, M_PI*2]
        rotationAnimation.duration = 0.5
        rotationAnimation.repeatCount = MAXFLOAT
        rotationAnimation.fillMode = kCAFillModeForwards
        rotationAnimation.isRemovedOnCompletion = false
        
        return rotationAnimation
    }
    
    
}

public extension UIImage{
    
    //颜色转图片
    public static func imageWithColor(_ targetColor:UIColor) -> UIImage {
        
        let rect:CGRect = CGRect.init(x: 0, y: 0, width: 1.0, height: 1.0)
        
        UIGraphicsBeginImageContext(rect.size)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(targetColor.cgColor)
        context?.fill(rect)
        
        let finalImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return finalImage!
    }
    
    
    
}

