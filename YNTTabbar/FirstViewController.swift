//
//  FirstViewController.swift
//  YNTTabbar
//
//  Created by bori－applepc on 16/9/27.
//  Copyright © 2016年 bori－applepc. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let bgImage = UIImageView(image: UIImage(named: "pic\(index!)"))
        bgImage.frame = view.frame
        view.addSubview(bgImage)
        
        // Do any additional setup after loading the view.
    }
}
