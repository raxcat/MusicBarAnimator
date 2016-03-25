//Original credit: http://imnotyourson.com/draggable-view-controller-interactive-view-controller/

public class MiniToLargeViewAnimator: BasicAnimator {

    public var initialY: CGFloat!
    
    public var kAnimationDuration: NSTimeInterval = 0.4
    
//    public weak var barView:UIView?
    
    public override func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kAnimationDuration
    }
    
    public override func animatePresentingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {
        
        let fromVCRect = transitionContext.initialFrameForViewController(fromVC)
        var toVCRect = fromVCRect
        toVCRect.origin.y = toVCRect.size.height - self.initialY
        
        toVC.view.frame = toVCRect
        let container = transitionContext.containerView()
        let imageView = self.fakeMiniView()
        toVC.view.addSubview(imageView)
        container?.addSubview(fromVC.view)
        container?.addSubview(toVC.view)
        
        UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
            toVC.view.frame = fromVCRect
            imageView.alpha = 0
            }) { (finished) -> Void in
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                }else{
                    transitionContext.completeTransition(true)
                }
        }
        
    }
    
    public override func animateDismissingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {
        
        var fromVCRect: CGRect = transitionContext.initialFrameForViewController(fromVC)
        fromVCRect.origin.y = fromVCRect.size.height - self.initialY
        
        let imageView = fakeMiniView()
        fromVC.view.addSubview(imageView)
        let container = transitionContext.containerView()
        container?.addSubview(toVC.view)
        container?.addSubview(fromVC.view)
        imageView.alpha = 0
        
        
        UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
            fromVC.view.frame = fromVCRect
            imageView.alpha = 1
            }) { (finished) -> Void in
                imageView.removeFromSuperview()
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                }else {
                    transitionContext.completeTransition(true)
                }
        }
        
        
    }
    
    func fakeMiniView() -> UIView {
        
        
        let dummyView: DummyView = DummyView(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, abs(initialY)))
        return dummyView
        
    }
    
}
