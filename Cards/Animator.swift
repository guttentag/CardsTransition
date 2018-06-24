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
    var cardData: CardData!
    var originView: UIView!
//    var dismissCompletion: (()->())?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
//        let herbView = self.presenting ? toView : transitionContext.view(forKey: .from)!
//        let herbView = self.presenting ? toView.subviews.first! : transitionContext.view(forKey: .from)!.subviews.first!
//        let herbView = self.presenting ? toView.subviews.first! : UIImageView(frame: transitionContext.view(forKey: .from)!.subviews.first!.frame)
//
//        let initialFrame = self.presenting ? self.originFrame : herbView.frame
//        let finalFrame = self.presenting ? herbView.frame : self.originFrame
//        print("***\ninitisl \(initialFrame.debugDescription)\nfinal \(finalFrame.debugDescription)\n***\n\(herbView.isHidden)")
//        let xScalarFactor = self.presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
//        let yScalarFactor = self.presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
//
//        let scaleTransform = CGAffineTransform(scaleX: xScalarFactor, y: yScalarFactor)
//
//        if self.presenting {
//            herbView.transform = scaleTransform
//            herbView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
//        } else {
//            (herbView as! UIImageView).image = (transitionContext.view(forKey: .from)!.subviews.first! as! UIImageView).image
//            (herbView as! UIImageView).contentMode = .scaleAspectFill
//
//            containerView.addSubview(herbView)
//        }
//        herbView.clipsToBounds = true
//        herbView.layer.cornerRadius = self.presenting ? 30 : 0
//
//        containerView.addSubview(toView)
//        containerView.bringSubview(toFront: herbView)
//
//        UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
//            herbView.transform = self.presenting ? CGAffineTransform.identity : scaleTransform
//            herbView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
//            herbView.layer.cornerRadius = self.presenting ? 0 : 30
//        }) { (_) in
//            if self.presenting == false {
//                self.dismissCompletion?()
//            }
//            transitionContext.completeTransition(true)
//        }
        
//        let image = #imageLiteral(resourceName: "image1") // TODO
//        let animatedView = UIImageView(image: image)
//        animatedView.translatesAutoresizingMaskIntoConstraints = false
//        animatedView.contentMode = .scaleAspectFill
//        animatedView.clipsToBounds = true

//        let animatedContainer = UIView()
//        animatedContainer.clipsToBounds = true
        
        let animatedView = CardView()
        animatedView.imageView.image = self.cardData.image
        animatedView.titleView.text = self.cardData.title
        animatedView.corners(self.presenting)
        
        if self.presenting {
            toView.alpha = 0
            self.originView.isHidden = true
        }
        
        containerView.addSubview(toView)
        containerView.addSubview(animatedView)
        containerView.bringSubview(toFront: animatedView)
        
        animatedView.heightAnchor.constraint(equalTo: animatedView.widthAnchor).isActive = true
        let topAnc = animatedView.topAnchor.constraint(equalTo: toView.topAnchor, constant: self.presenting ? self.originFrame.minY : 20)
        let leadingAnc = animatedView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: self.presenting ? self.originFrame.minX : 0)
        let trailingAnc = animatedView.trailingAnchor.constraint(equalTo: self.presenting ? toView.leadingAnchor : toView.trailingAnchor, constant: self.presenting ? self.originFrame.maxX : 0)
        
        topAnc.isActive = true
        leadingAnc.isActive = true
        trailingAnc.isActive = true
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
        topAnc.isActive = false
        leadingAnc.isActive = false
        trailingAnc.isActive = false
        
        animatedView.topAnchor.constraint(equalTo: toView.topAnchor, constant: self.presenting ? 20 : self.originFrame.minY).isActive = true
        animatedView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: self.presenting ? 0 : self.originFrame.minX).isActive = true
        animatedView.trailingAnchor.constraint(equalTo: self.presenting ? toView.trailingAnchor : toView.leadingAnchor, constant: self.presenting ? 0 : self.originFrame.maxX).isActive = true

        UIView.animateKeyframes(withDuration: self.duration, delay: 0, options: [.calculationModeLinear], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
                containerView.layoutIfNeeded()
                animatedView.corners(!self.presenting)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
                if self.presenting {
                    
                }
            })
        }) { (_) in
            if self.presenting {
                animatedView.isHidden = true
            } else {
                self.originView.isHidden = false
//                self.dismissCompletion?()
            }
            
            toView.alpha = 1
            transitionContext.completeTransition(true)
            
        }
//        UIView.animate(withDuration: self.duration, animations: {
//            containerView.layoutIfNeeded()
//            animatedView.corners(!self.presenting)
//        }) { (_) in
//            if self.presenting {
//                animatedView.isHidden = true
//            } else {
//                self.originView.isHidden = false
////                self.dismissCompletion?()
//            }
//
//            toView.alpha = 1
//            transitionContext.completeTransition(true)
//        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    
}
