//
//  NavigationAnimator.swift
//  Cards
//
//  Created by Eran Guttentag on 18/06/2018.
//  Copyright © 2018 Reali. All rights reserved.
//

import UIKit

class NavigationAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    let duration = 2.0
    var operation = UINavigationControllerOperation.push
    var originalImageView: UIImageView?
    var originalFrame: CGRect?
    
    weak var storedContext: UIViewControllerContextTransitioning?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.storedContext = transitionContext

        let from = transitionContext.view(forKey: .from)!
        let to = transitionContext.view(forKey: .to)!
        
        let push = self.operation == .push
        
        
        let initialFrame = push ? originalFrame! : (transitionContext.viewController(forKey: .from) as! DetinationViewController).imageView.frame
        let finalFrame = push ? to.subviews.first!.frame : self.originalFrame!
        print("***\ninitisl \(initialFrame.debugDescription)\nfinal \(finalFrame.debugDescription)\n***")
    
//        let animated = UIImageView(frame: initialFrame)
//        animated.contentMode = .scaleAspectFill
//        animated.clipsToBounds = true
//        animated.layer.cornerRadius = push ? 10 : 0
        let animated = push ? (transitionContext.viewController(forKey: .to) as! DetinationViewController).imageView! : self.originalImageView!
        animated.isHidden = false
        
        let xScalarFactor = push ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScalarFactor = push ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScalarFactor, y: yScalarFactor)
        
//        if self.presenting {
            animated.transform = scaleTransform
            animated.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
//        } else {
//            (herbView as! UIImageView).image = (transitionContext.view(forKey: .from)!.subviews.first! as! UIImageView).image
//            (herbView as! UIImageView).contentMode = .scaleAspectFill
//
//            containerView.addSubview(herbView)
//        }

        transitionContext.containerView.addSubview(to)
        transitionContext.containerView.bringSubview(toFront: animated)
        
        UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            animated.transform = push ? CGAffineTransform.identity : scaleTransform
            animated.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            animated.layer.cornerRadius = push ? 0 : 30
        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
}
