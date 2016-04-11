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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    func movieViewDestRect() -> CGRect {
        guard let v = self.imageview else {
            return CGRectZero
        }
        return v.frame
    }
    func destMovieView() -> UIView {
        guard let v = self.imageview else {
            return self.view
        }
        return self.imageview
    }
    
    @IBOutlet weak var imageview: UIImageView!

    @IBAction func dismiss(){
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
