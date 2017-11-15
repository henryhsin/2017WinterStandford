//
//  MyImageViewController.swift
//  Lecture7ScrollView
//
//  Created by 辛忠翰 on 15/11/17.
//  Copyright © 2017 辛忠翰. All rights reserved.
//

import UIKit

class MyImageViewController: UIViewController {
    private var imageView = UIImageView()
    @IBOutlet weak var scrollView: UIScrollView!{
        didSet{
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size//當scrollView第一次被設置時，要設定一次content size(另一個當image change時要再設定一次新的contenSize)
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
            scrollView.addSubview(imageView)
        }
    }
    private var image: UIImage?{
        get{
            return imageView.image
        }
        set{
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size//這邊的scrollView要為optional，因為在imgUrl的部分會將image設為nil，也會導致scrollView變為nil，這會使得app crash掉，所以要設scrollview為optional（當圖片change時，從新設定content size）
        }
    }
    
    var imgUrl: URL?{
        didSet{//賦值後執行
            image = nil
            if view.window != nil{
                fetchImg()
            }
        }
    }
    
    private func fetchImg() {
        if let url = imgUrl{
            let urlContents = try? Data(contentsOf: url)
            if let imgData = urlContents{
                image = UIImage(data: imgData)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil{
            fetchImg()
        }
    }
}

extension MyImageViewController: UIScrollViewDelegate{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
