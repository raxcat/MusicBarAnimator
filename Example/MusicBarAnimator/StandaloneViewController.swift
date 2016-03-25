//
//  StandaloneViewController.swift
//  MusicBarAnimator
//
//  Created by raxcat on 2016/3/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class StandaloneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBOutlet weak var imageview: UIImageView!

    @IBAction func dismiss(){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
