//Original credit: http://imnotyourson.com/draggable-view-controller-interactive-view-controller/

public class MiniToLargeViewAnimator: BasicAnimator {

    public var initialY: CGFloat!
    
    public var kAnimationDuration: NSTimeInterval = 0.4
    
    public weak var barView:UIView?
    
    public override func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kAnimationDuration
    }
    
    public override func animatePresentingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {
        
        let fromVCRect = transitionContext.initialFrameForViewController(fromVC)
        var toVCRect = fromVCRect
        toVCRect.origin.y = toVCRect.size.height //- self.initialY
        
        toVC.view.frame = toVCRect
        let container = transitionContext.containerView()
        let imageView = self.fakeMiniView()
        container?.addSubview(imageView)
        container?.addSubview(toVC.view)
        
        var barFrame = imageView.frame
        barFrame.origin.y = fromVCRect.origin.y - CGRectGetHeight(barFrame)
        
        
        UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
            toVC.view.frame = fromVCRect
            imageView.frame = barFrame
            imageView.alpha = 0.0
            fromVC.view.alpha = 0.0
            }) { (finished) -> Void in
                fromVC.view.alpha = 1.0
                imageView.removeFromSuperview()
                
                if transitionContext.transitionWasCancelled() {
                    transitionContext.completeTransition(false)
                }else{
                    transitionContext.completeTransition(true)
                }
        }
        
    }
    
    public override func animateDismissingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {
        
        var fromVCRect: CGRect = transitionContext.initialFrameForViewController(fromVC)
        fromVCRect.origin.y = fromVCRect.size.height
        
        
        let container = transitionContext.containerView()
        
        let imageView = fakeMiniView()
        var barFrame = imageView.frame
        barFrame.origin = CGPoint(x: 0.0, y: -CGRectGetHeight(barFrame))
        imageView.frame = barFrame
        fromVC.view.addSubview(imageView)
        imageView.backgroundColor = UIColor.greenColor()
        container?.insertSubview(toVC.view, atIndex: 0)
        
        toVC.view.alpha = 0.0
        imageView.alpha = 0.0
        
        UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
            fromVC.view.frame = fromVCRect
            imageView.alpha = 1.0
            toVC.view.alpha = 1.0
            
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
        guard let view = self.barView else {
            let dummyView: DummyView = DummyView(frame: CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.size.width, abs(initialY)))
            return dummyView
        }
        print("fake mini :\(view)")
        let imageView =  UIImageView(frame: view.frame)
        imageView.image = view.snapshot()
        return imageView
    }
    
}
