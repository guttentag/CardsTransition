//
//  Animator.swift
//  Cards
//
//  Created by Eran Guttentag on 18/06/2018.
//  Copyright © 2018 Reali. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 2.0
    var presenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (()->())?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        
        let herbView = self.presenting ? toView : transitionContext.view(forKey: .from)!
//        let herbView = self.presenting ? toView.subviews.first! : (transitionContext.viewController(forKey: .from) as! DetinationViewController).imageView

        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.originFrame

        let xScalarFactor = self.presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScalarFactor = self.presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScalarFactor, y: yScalarFactor)

        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            herbView.clipsToBounds = true
        }

        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)

        UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        }) { (_) in
            if self.presenting == false {
                self.dismissCompletion?()
            }
            transitionContext.completeTransition(true)
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    
}
