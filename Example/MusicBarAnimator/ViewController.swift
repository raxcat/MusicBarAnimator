//
//  ViewController.swift
//  MusicBarAnimator
//
//  Created by raxcat on 03/11/2016.
//  Copyright (c) 2016 raxcat. All rights reserved.
//

import UIKit
import MusicBarAnimator

class ViewController: UIViewController, UIViewControllerTransitioningDelegate, MiniToLargeViewAnimatorExtra {

    
    var disableInteractivePlayerTransitioning: Bool =  false
//    weak var dummyView:DummyView? = nil
    var standaloneViewController: StandaloneViewController?
    
    @IBOutlet weak var testView: UIImageView!
    @IBOutlet weak var movieView: UIImageView!
    @IBOutlet weak var barView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIScreen.mainScreen().bounds)
        
        if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("standalone") as? StandaloneViewController{
            vc.transitioningDelegate = self
            self.standaloneViewController = vc
        }
        
        self.presentIndicator = MiniToLargeViewInteractor()
        self.presentIndicator?.attachToViewController(self, withView: self.barView, presentViewController: self.standaloneViewController)
        self.dismissIndicator = MiniToLargeViewInteractor()
        if let view = self.standaloneViewController?.view, vc = self.standaloneViewController {
            self.dismissIndicator?.attachToViewController(vc, withView: view)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.disableInteractivePlayerTransitioning = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func clicked(sender: AnyObject) {
        self.showStandaloneViewController()
    }
    
    @IBAction func unwindToMainViewController(segue:UIStoryboardSegue) {
        print("unwind: \(self.barView)")
        self.disableInteractivePlayerTransitioning = true
    }
    
    func showStandaloneViewController()->Void{
        guard let vc = self.standaloneViewController else {return}
        self.showViewController(vc, sender: self)
    }
    
    let kButtonHeight: CGFloat = 50;
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        animator.initialY = kButtonHeight
        animator.barView = self.barView
        animator.movieView = self.movieView
        animator.transitionType = BasicAnimator.ModalAnimatedTransitioningType.Present
        return animator
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = MiniToLargeViewAnimator()
        animator.initialY = kButtonHeight
        animator.barView = self.barView
        animator.transitionType = BasicAnimator.ModalAnimatedTransitioningType.Dismiss
        guard let standalone = self.presentedViewController as? StandaloneViewController else {
            return animator
        }
        animator.movieView = standalone.imageview
        return animator
    }
    
    var presentIndicator:MiniToLargeViewInteractor? = nil
    var dismissIndicator:MiniToLargeViewInteractor? = nil
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.disableInteractivePlayerTransitioning {
            return nil
        }
        return self.presentIndicator
    }
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.disableInteractivePlayerTransitioning {
            return nil
        }
        return self.dismissIndicator
    }
    
    func movieViewDestRect() -> CGRect {
        return CGRectMake(146, 302, 203, 138)
    }

}

