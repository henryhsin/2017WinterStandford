//
//  CassniViewController.swift
//  Lecture7ScrollView
//
//  Created by 辛忠翰 on 15/11/17.
//  Copyright © 2017 辛忠翰. All rights reserved.
//

import UIKit

class CassniViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let url = DemoUrl.NasaUrlStrings[segue.identifier ?? ""]{
            if let imgVC = segue.destination.contents as? MyImageViewController{
                imgVC.imgUrl = URL(string: url)
                imgVC.title = (sender as? UIButton)?.currentTitle
            }
        }
        
    }
    

}
extension UIViewController{
    var contents: UIViewController{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        }else{
            return self
        }
    }
}

