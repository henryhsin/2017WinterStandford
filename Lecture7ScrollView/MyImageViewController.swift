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
            scrollView?.contentSize = imageView.frame.size
            //這邊的scrollView要為optional，因為在imgUrl的部分會將image設為nil，也會導致scrollView變為nil，這會使得app crash掉，所以要設scrollview為optional（當圖片change時，從新設定content size）
            spinner?.stopAnimating()
            spinner?.isHidden = true
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
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    private func fetchImg() {
        if let url = imgUrl{
            //First way : Use URLSession. We run downloading img on some other queue, and run UI back to mainQueue
            //URLSession is running on some other Queue
            /*
             let session = URLSession(configuration: .default)
             let task = session.dataTask(with: url, completionHandler: { (data, response, err) in
             if let imgData = data, url == self.imgUrl{
             //確保現在的self.imgUrl是否與抓到的url相同。有可能使用者在案earth後，又立即按了surtan，此時會產生兩個seesion。而第一個session中的抓到的earth圖片我們不在需要。所以一開始的imgUrl為earth且url也為earth。然而當我們按了saturn，此時的imgUrl變為saturn，當第一個seesion抓到圖片要處理data時，可以做判斷是否與現在的url還相同
             DispatchQueue.main.async {
             self.image = UIImage(data: imgData)
             }
             }else{
             print(err.debugDescription)
             }
             })
             task.resume()
             */
            //
            
            //Second way: we create a global concurrent queue
            //weak 代表讓他變為optional
            //若user按了earth後，又返回上頁按Saturn。當按back會讓memory中的window heap將navigation controller pop出去，然而closure會強迫其留在heap中，不會讓他被pop出去。所以需要當navigation controller pop出去後，將self設成nil，好讓它從heap離開
            spinner.isHidden = false
            spinner.startAnimating()
            DispatchQueue.global(qos: .userInteractive).async {[weak self] in
                let urlContents = try? Data(contentsOf: url)
                if let imgData = urlContents, url == self?.imgUrl{
                    DispatchQueue.main.async {
                        self?.image = UIImage(data: imgData)
                    }
                }
            }
            //
            //The most terrible way, run downloading Img on main queue
            /*
             let urlContents = try? Data(contentsOf: url)
             if let imgData = urlContents{
             self.image = UIImage(data: imgData)
             }
             */
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
