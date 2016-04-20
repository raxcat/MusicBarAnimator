//
//  StandaloneViewController.swift
//  MusicBarAnimator
//
//  Created by raxcat on 2016/3/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MusicBarAnimator
class StandaloneViewController: UIViewController, MiniToLargeViewAnimatorExtra{

    var viewController:ViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    @IBOutlet weak var imageview: UIImageView!

    @IBOutlet weak var addtoView: UIButton!
    @IBAction func clickAddToView(sender: AnyObject) {
        
        viewController?.addPlayerLayerToView()
    }
    
    @IBAction func dismiss(){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
