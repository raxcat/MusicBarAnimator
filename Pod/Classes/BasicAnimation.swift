//Original credit: http://imnotyourson.com/draggable-view-controller-interactive-view-controller/

import UIKit

public class BasicAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    public enum ModalAnimatedTransitioningType: Int {
        case Present
        case Dismiss
    }

    public var transitionType: ModalAnimatedTransitioningType!
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.4
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let to: UIViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        let from: UIViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        if self.transitionType == ModalAnimatedTransitioningType.Present {
            self.animatePresentingInContext(transitionContext, toVC: to, fromVC: from)
        }else if self.transitionType == ModalAnimatedTransitioningType.Dismiss {
            self.animateDismissingInContext(transitionContext, toVC: to, fromVC: from)
        }
        
    }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
   
    public func animatePresentingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {}
    public func animateDismissingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {}

}