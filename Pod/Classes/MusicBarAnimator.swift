//
//  PopAnimator.swift
//
//  Created by raxcat on 2016/2/26.
//  Copyright © 2016年 raxcat ltd. All rights reserved.
//

import UIKit

public class MusicBarAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public let duration    = 0.8
    public var presenting  = true
    public var usingSpringWithDamping = 0.8
    public var initialSpringVelocity = 1.0
    public var barView: UIView? = nil
    public var viewForDarkness: UIView? = nil
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()!
        if presenting {
            let fromView = barView ?? transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            let origFrmae = fromView.frame
            toView.frame.origin = CGPoint(x: CGRectGetMinX(containerView.frame), y:CGRectGetMaxY(containerView.frame))
            containerView.addSubview(toView)
            viewForDarkness?.alpha = 1.0
            
            if transitionContext.isInteractive() == true {
                UIView.animateWithDuration(duration, delay: 0, options: [.CurveLinear],animations: { [weak self]() -> Void in
                    fromView.frame = CGRect(x: CGRectGetMinX(fromView.frame), y: CGRectGetMinY(fromView.frame)-CGRectGetHeight(containerView.frame) , width: CGRectGetWidth(fromView.frame), height: CGRectGetHeight(fromView.frame))
                    toView.frame = containerView.bounds
                    self?.viewForDarkness?.alpha = 0.0
                    }, completion: {[weak self] (complete) -> Void in
                        self?.viewForDarkness?.alpha = 1.0
                        fromView.frame = origFrmae
                        self?.barView = nil
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    })
            }
            else {
                UIView.animateWithDuration(duration, delay:0.0,
                    usingSpringWithDamping: CGFloat(usingSpringWithDamping),
                    initialSpringVelocity: CGFloat(initialSpringVelocity),
                    options: [],
                    animations: {
                        fromView.frame = CGRect(x: CGRectGetMinX(fromView.frame), y: CGRectGetMinY(fromView.frame)-CGRectGetHeight(containerView.frame) , width: CGRectGetWidth(fromView.frame), height: CGRectGetHeight(fromView.frame))
                        toView.frame = containerView.bounds
                        
                    }, completion:{ [weak self](complete) -> Void in
                        fromView.frame = origFrmae
                        self?.barView = nil
                        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
                    })
            }
        }else{
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey)!
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
            
            let barImageView = UIImageView(frame: barView!.frame)
            barImageView.image = barView!.snapshot()
            
            barImageView.frame = CGRect(x: CGRectGetMinX(barImageView.frame), y: 0 - CGRectGetHeight(barImageView.frame), width: CGRectGetWidth(barImageView.frame), height: CGRectGetHeight(barImageView.frame))
            barImageView.backgroundColor = UIColor.greenColor()
            containerView.addSubview(barImageView)
            
            let backgroundImageView = UIImageView(frame:containerView.bounds)
            backgroundImageView.image = toView.snapshot()
            containerView.insertSubview(backgroundImageView, atIndex: 0)
            
            UIView.animateWithDuration(duration, delay:0.0,
                usingSpringWithDamping: CGFloat(usingSpringWithDamping),
                initialSpringVelocity: CGFloat(initialSpringVelocity),
                options: [],
                animations: {
                    barImageView.frame = CGRect(x: CGRectGetMinX(barImageView.frame), y: CGRectGetMaxY(containerView.frame)-CGRectGetHeight(barImageView.frame), width: CGRectGetWidth(barImageView.frame), height: CGRectGetHeight(barImageView.frame))
                    
                    fromView.frame = CGRect(x: CGRectGetMinX(fromView.frame), y: CGRectGetMaxY(fromView.frame), width: CGRectGetWidth(fromView.frame), height: CGRectGetHeight(fromView.frame))
                    
                }, completion:{ (complete) -> Void in
                    containerView.addSubview(toView)
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        }
    }
}

extension UIView {
    ///Use this method to render an image object.
    /// - parameter userLayer : If true, this method use older method renderInContext: to draw. Else, iOS7 new method drawViewHierarchyInRect: is used.
    ///
    /// - Note: Use iOS7 new drawing method cause some issues under circumstances of container view when doing custom view controller transition.
    func snapshot(useLayer:Bool = true) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        if(useLayer == false){
            self.drawViewHierarchyInRect(self.bounds, afterScreenUpdates: true)
        }else{
            layer.renderInContext(UIGraphicsGetCurrentContext()!)
        }
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

