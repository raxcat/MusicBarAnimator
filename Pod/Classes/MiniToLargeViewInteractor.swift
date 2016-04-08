//
//  MinToLargeViewInteractive.swift
//  Pods
//
//  Created by raxcat on 2016/3/25.
//
//

import UIKit

public class MiniToLargeViewInteractor: UIPercentDrivenInteractiveTransition {
    public var viewController:UIViewController!
    public var presentViewController:UIViewController?
    public var panGesture:UIPanGestureRecognizer!
    
    var shouldComplete:Bool = false
    
    public func attachToViewController(viewController:UIViewController, withView view:UIView, presentViewController:UIViewController?=nil) {
        self.viewController = viewController
        self.presentViewController = presentViewController
        self.panGesture = UIPanGestureRecognizer(target: self, action: "onPan:")
        view.addGestureRecognizer(self.panGesture)
    }
    
    func onPan(pan:UIPanGestureRecognizer)-> Void{
        let translation = pan.translationInView(pan.view?.superview)
        
        switch pan.state {
        case .Began:
            if self.presentViewController == nil {
                self.viewController .dismissViewControllerAnimated(true, completion: nil)
            }else if let present = self.presentViewController {
                self.viewController.presentViewController(present, animated: true, completion: nil)
            }
        case .Changed :
            let screenHeight:CGFloat = UIScreen.mainScreen().bounds.size.height - 44.0
            let DragAmount:CGFloat = self.presentViewController == nil ? screenHeight : -screenHeight
            let Threhold:CGFloat = 0.3
            var percent = translation.y / DragAmount
            percent = CGFloat(fmaxf(Float(percent), 0.0))
            percent = CGFloat(fminf(Float(percent), 1.0))
            self.updateInteractiveTransition(percent)
            self.shouldComplete = percent > Threhold
        case .Ended:
            fallthrough
        case .Cancelled:
            
            if pan.state == .Cancelled || !self.shouldComplete {
                self.cancelInteractiveTransition()
            } else {
                self.finishInteractiveTransition()
            }
            
        default:
            print()
        }
    }

}
