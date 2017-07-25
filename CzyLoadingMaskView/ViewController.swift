//
//  ViewController.swift
//  CzyLoadingMaskView
//
//  Created by macOfEthan on 17/7/24.
//  Copyright © 2017年 macOfEthan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var imageV: UIImageView!
    
    var urls:[String] = ["http://imgsrc.baidu.com/imgad/pic/item/267f9e2f07082838b5168c32b299a9014c08f1f9.jpg",
                         "http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=60aeee5da74bd11310c0bf7132c6ce7a/72f082025aafa40fe3c0c4f3a164034f78f0199d.jpg",
                         "http://pic39.nipic.com/20140318/496038_202510516000_2.jpg"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func addImageView(_ sender: UIButton) {
        
        imageV!.createCzyImage(imageUrl: urls[(Int)(arc4random_uniform(UInt32(urls.count)))],   placeHolderImage: UIImage.imageWithColor(UIColor.lightGray))
    }


}

