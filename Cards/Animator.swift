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
        
//        let herbView = self.presenting ? toView : transitionContext.view(forKey: .from)!
//        let herbView = self.presenting ? toView.subviews.first! : transitionContext.view(forKey: .from)!.subviews.first!
        let herbView = self.presenting ? toView.subviews.first! : UIImageView(frame: transitionContext.view(forKey: .from)!.subviews.first!.frame)

        let initialFrame = self.presenting ? self.originFrame : herbView.frame
        let finalFrame = self.presenting ? herbView.frame : self.originFrame
        print("***\ninitisl \(initialFrame.debugDescription)\nfinal \(finalFrame.debugDescription)\n***\n\(herbView.isHidden)")
        let xScalarFactor = self.presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScalarFactor = self.presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height

        let scaleTransform = CGAffineTransform(scaleX: xScalarFactor, y: yScalarFactor)

        if self.presenting {
            herbView.transform = scaleTransform
            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
        } else {
            (herbView as! UIImageView).image = (transitionContext.view(forKey: .from)!.subviews.first! as! UIImageView).image
            (herbView as! UIImageView).contentMode = .scaleAspectFill
            
            containerView.addSubview(herbView)
        }
        herbView.clipsToBounds = true
        herbView.layer.cornerRadius = self.presenting ? 30 : 0

        containerView.addSubview(toView)
        containerView.bringSubview(toFront: herbView)

        UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            herbView.layer.cornerRadius = self.presenting ? 0 : 30
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
