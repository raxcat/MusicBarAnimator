//Original credit: http://imnotyourson.com/draggable-view-controller-interactive-view-controller/

import UIKit

public class DummyView: UIView {

    public weak var button: UIButton!
    
    override init (frame : CGRect) {
        super.init(frame : frame)
        addBehavior()
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    func addBehavior (){

        let bottomButton: UIButton = UIButton(type: .Custom)
        bottomButton.translatesAutoresizingMaskIntoConstraints = false
        bottomButton.backgroundColor = UIColor.grayColor()
        bottomButton.setTitle("Tap or drag me", forState: .Normal)
        self.addSubview(bottomButton)
        
        self.addConstraint(NSLayoutConstraint(item: bottomButton, attribute: .Top, relatedBy: .Equal, toItem: bottomButton.superview, attribute: .Top, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: bottomButton, attribute: .Right, relatedBy: .Equal, toItem: bottomButton.superview, attribute: .Right, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: bottomButton, attribute: .Left, relatedBy: .Equal, toItem: bottomButton.superview, attribute: .Left, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: bottomButton, attribute: .Bottom, relatedBy: .Equal, toItem: bottomButton.superview, attribute: .Bottom, multiplier: 1.0, constant: 0))
        
        
        
        self.button = bottomButton
        
    }

}