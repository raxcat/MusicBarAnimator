//Original credit: http://imnotyourson.com/draggable-view-controller-interactive-view-controller/

import AVFoundation

public class MiniToLargeViewAnimator: BasicAnimator {

    ///InitialY from the bottom
    public var initialY: CGFloat!
    
    //Duration
    public var kAnimationDuration: NSTimeInterval = 0.4
    
    //Mini music bar view
    public weak var barView:UIView?
    
    //The movie view you wanna show in animation process. (Optional)
    public weak var movieView:UIView?
    
    //AVPlayerLayer you want to animate(optional)
    public weak var movieLayer:AVPlayerLayer?
    
    public override func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return kAnimationDuration
    }
    
    //Presenting animation implementation
    public override func animatePresentingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {
        
        let fromVCRect = transitionContext.initialFrameForViewController(fromVC)
        var toVCRect = fromVCRect
        toVCRect.origin.y = toVCRect.size.height
        
        toVC.view.frame = toVCRect
        let container = transitionContext.containerView()
        let fakeMiniBarView = self.fakeMiniView()
        container?.addSubview(fakeMiniBarView)
        container?.addSubview(toVC.view)
        
        //calculate mini bar animation frame
        var barFrame = fakeMiniBarView.frame
        barFrame.origin.y = fromVCRect.origin.y - CGRectGetHeight(barFrame)
        
        //calculate movie view animation frame
        var movieDestRect = CGRectZero
        var movieOriginalRect = CGRectZero
        var movieOriginalView:UIView? = nil
        
        toVC.view.layoutSubviews()  //force toVC.view auto layout to calculate runtime frame
        movieDestRect = (toVC as? MiniToLargeViewAnimatorExtra)?.movieViewDestRect?() ?? CGRectZero
        if let layer = self.movieLayer, view = self.movieView {
            movieOriginalRect = layer.frame
            
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            layer.removeFromSuperlayer()
            container?.layer.addSublayer(layer)
            layer.frame = movieDestRect
            CATransaction.commit()
            
            let animation = CABasicAnimation(keyPath: "position")
            animation.fromValue = NSValue(CGPoint: CGPointMake(CGRectGetMidX(view.frame), CGRectGetMidY(view.frame)))
            animation.toValue = NSValue(CGPoint:CGPointMake(CGRectGetMidX(movieDestRect), CGRectGetMidY(movieDestRect)))
            animation.duration = self.kAnimationDuration
            
            let sizeAnimation = CABasicAnimation(keyPath:"bounds")
            sizeAnimation.fromValue = NSValue(CGRect:view.bounds)
            sizeAnimation.toValue = NSValue(CGRect:CGRectMake(0, 0, movieDestRect.size.width, movieDestRect.size.height))
            sizeAnimation.duration = self.kAnimationDuration
            
            let group = CAAnimationGroup()
            group.duration = self.kAnimationDuration
            group.animations = [animation, sizeAnimation]
            layer.addAnimation(group, forKey: nil)

        }
        
        UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
            toVC.view.frame = fromVCRect
            fakeMiniBarView.frame = barFrame
            fromVC.view.alpha = 0.0
            
        }) { (finished) -> Void in
            fromVC.view.alpha = 1.0
            fakeMiniBarView.removeFromSuperview()
            
            if transitionContext.transitionWasCancelled() {
                transitionContext.completeTransition(false)
            }else{
                if let layer = self.movieLayer , destMovieView = (toVC as? MiniToLargeViewAnimatorExtra)?.destMovieView?(){
                    CATransaction.begin()
                    CATransaction.setDisableActions(true)
                    layer.removeFromSuperlayer()
                    layer.frame = destMovieView.bounds
                    destMovieView.layer.addSublayer(layer)
                    CATransaction.commit()
                }
                
                transitionContext.completeTransition(true)
            }
        }
        
    }
    
    //Presenting animation implementation
    public override func animateDismissingInContext(transitionContext: UIViewControllerContextTransitioning, toVC: UIViewController, fromVC: UIViewController) {
        
        let container = transitionContext.containerView()
        var movieDestRect = CGRectZero
        var movieOriginalRect = CGRectZero
        
        toVC.view.layoutSubviews()  //force toVC.view auto layout to calculate runtime frame
        movieDestRect = (toVC as? MiniToLargeViewAnimatorExtra)?.movieViewDestRect?() ?? CGRectZero
        if let movieView = self.movieView {
            movieOriginalRect = movieView.frame
            movieView.frame = movieView.superview!.convertRect(movieView.frame, toView:fromVC.view)
            movieView.removeFromSuperview()
            movieView.translatesAutoresizingMaskIntoConstraints = true
            movieView.removeConstraints(movieView.constraints)
            container?.addSubview(movieView)
        }
        
        var fromVCRect: CGRect = transitionContext.initialFrameForViewController(fromVC)
        fromVCRect.origin.y = fromVCRect.size.height
        
        let imageView = fakeMiniView()
        var barFrame = imageView.frame
        barFrame.origin = CGPoint(x: 0.0, y: -CGRectGetHeight(barFrame))
        imageView.frame = barFrame
        fromVC.view.addSubview(imageView)
        imageView.backgroundColor = UIColor.greenColor()
        container?.insertSubview(toVC.view, atIndex: 0)
        
        toVC.view.alpha = 0.0
        
        UIView.animateWithDuration(kAnimationDuration, animations: { () -> Void in
            fromVC.view.frame = fromVCRect
            imageView.alpha = 1.0
            toVC.view.alpha = 1.0
            self.movieView?.frame = movieDestRect
            
            }) { (finished) -> Void in
                imageView.removeFromSuperview()
                if let movieView = self.movieView {
                    movieView.removeFromSuperview()
                    fromVC.view.addSubview(movieView)
                    movieView.frame = movieOriginalRect
                }
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
        let imageView =  UIImageView(frame: view.frame)
        imageView.image = view.snapshot()
        return imageView
    }
}

@objc public protocol MiniToLargeViewAnimatorExtra{
    optional func movieViewDestRect() -> CGRect
    optional func destMovieView() -> UIView
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
