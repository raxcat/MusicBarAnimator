//
//  StandaloneViewController.swift
//  MusicBarAnimator
//
//  Created by brianliu on 2016/3/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit

class StandaloneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let panGesture = UIPanGestureRecognizer(target: self, action: "detailPanned:")
        self.view.addGestureRecognizer(panGesture)

    }

    @IBOutlet weak var imageview: UIImageView!

    
    func detailPanned(recoginzer:UIPanGestureRecognizer){
        
        if recoginzer.state == .Began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition?.completionCurve = .Linear
            
        }
        
        guard let view = recoginzer.view else {return}
        guard let superview = view.superview else {return}
        
        let pointInFrame = recoginzer.translationInView(superview)
        var height = superview.bounds.height
        
        
        var progress = 0 - (pointInFrame.y / ( CGFloat(height) * 1.0))
        progress = min(1.0, max(0.0, progress));
        print(height)
        switch recoginzer.state {
        case .Began:
            
        case .Changed:
            
        case .Ended:
            fallthrough
        case .Cancelled:
            pointInBounds = CGPointZero
            if progress > 0.5 {
                interactiveTransition?.finishInteractiveTransition()
            }else{
                interactiveTransition?.cancelInteractiveTransition()
            }
            interactiveTransition = nil
            
        default:
            pointInBounds = CGPointZero
            
        }
    }
}
