//
//  BarViewController.swift
//  MusicBarAnimator
//
//  Created by brianliu on 2016/3/24.
//  Copyright © 2016年 CocoaPods. All rights reserved.
//

import UIKit
import MusicBarAnimator

class BarViewController: UIViewController,UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        let gesture = UITapGestureRecognizer(target: self, action: "miniplayerTapped:")
        gesture.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(gesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "miniPlayerPanned:")
        self.view.addGestureRecognizer(panGesture)
        
        gesture.requireGestureRecognizerToFail(panGesture)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func miniplayerTapped(recognizer:UITapGestureRecognizer){
        self.showStandalone()
    }
    var pointInBounds:CGPoint = CGPointZero
    func miniPlayerPanned(recoginzer:UIPanGestureRecognizer){
        
        if recoginzer.state == .Began {
            interactiveTransition = UIPercentDrivenInteractiveTransition()
            interactiveTransition?.completionCurve = .Linear
            self.showStandalone()
        }
        
        let pointInFrame = recoginzer.translationInView(self.view.superview)
        guard var height = self.parentViewController?.view.bounds.size.height else {return}
        height -= self.view.bounds.height
        
        var progress = 0 - (pointInFrame.y / ( CGFloat(height) * 1.0))
        progress = min(1.0, max(0.0, progress));
        
        switch recoginzer.state {
        case .Began:
            pointInBounds = recoginzer.translationInView(self.view)
        case .Changed:
            interactiveTransition?.updateInteractiveTransition(progress)
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
    
    
    
    @IBAction func showStandalone()->Void{
        guard let vc = self.storyboard?.instantiateViewControllerWithIdentifier("detail") else {
            return
        }
        vc.transitioningDelegate = self
        self.showViewController(vc, sender: self)
    }

    // MARK: - Custom Animation
    let transition = MusicBarAnimator()
    var interactiveTransition: UIPercentDrivenInteractiveTransition?
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) ->
        UIViewControllerAnimatedTransitioning? {
            transition.presenting = true
            transition.barView = self.view
            transition.viewForDarkness = self.parentViewController?.view
            return transition
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        transition.barView = self.view
        return transition
    }
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }

    
    
    @IBAction func unwindToBarViewController(segue:UIStoryboardSegue) {
        guard let detail = segue.sourceViewController as? StandaloneViewController else{
            return
        }

        
    }
    

    
}
