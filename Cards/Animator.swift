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
    var dismissCompletion: (()->())?
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toView = transitionContext.view(forKey: .to)!
        let fromView = transitionContext.view(forKey: .from)!
        
        containerView.backgroundColor = UIColor.white
        
        let animatedView = CardView()
        animatedView.imageView.image = self.cardData.image
        animatedView.titleView.text = self.cardData.title
        animatedView.corners(self.presenting)
        
        if self.presenting {
            toView.isHidden = true
            self.originView.isHidden = true
        }
        
        let detailsView = self.presenting ? toView : fromView
        let detailsContainer = UIView()
        detailsContainer.clipsToBounds = true
        detailsContainer.addSubview(detailsView)
        detailsContainer.translatesAutoresizingMaskIntoConstraints = false
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        detailsView.topAnchor.constraint(equalTo: detailsContainer.topAnchor).isActive = true
        detailsView.centerXAnchor.constraint(equalTo: detailsContainer.centerXAnchor).isActive = true
        
        containerView.addSubview(detailsContainer)
        detailsView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        detailsView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -20).isActive = true

        if !self.presenting {
            containerView.addSubview(toView)
        }
        containerView.addSubview(detailsContainer)
        containerView.addSubview(animatedView)
        containerView.bringSubview(toFront: animatedView)
        
        animatedView.heightAnchor.constraint(equalTo: animatedView.widthAnchor).isActive = true
        let cardTopAnc = animatedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: self.presenting ? self.originFrame.minY : 20)
        let cardLeadingAnc = animatedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: self.presenting ? self.originFrame.minX : 0)
        let cardTrailingAnc = animatedView.trailingAnchor.constraint(equalTo: self.presenting ? containerView.leadingAnchor : containerView.trailingAnchor, constant: self.presenting ? self.originFrame.maxX : 0)

        let topAnc = detailsContainer.topAnchor.constraint(equalTo: animatedView.topAnchor)
        let leadingAnc = detailsContainer.leadingAnchor.constraint(equalTo: animatedView.leadingAnchor)
        let trailingAnc = detailsContainer.trailingAnchor.constraint(equalTo: animatedView.trailingAnchor)
        let bottomAnc = detailsContainer.bottomAnchor.constraint(equalTo: animatedView.bottomAnchor)
        
        topAnc.isActive = true
        leadingAnc.isActive = true
        trailingAnc.isActive = true
        bottomAnc.isActive = true
        
        cardTopAnc.isActive = true
        cardLeadingAnc.isActive = true
        cardTrailingAnc.isActive = true
        
        containerView.setNeedsLayout()
        containerView.layoutIfNeeded()
        
        
        UIView.animate(withDuration: self.duration / 2.0, animations: {
            cardTopAnc.isActive = false
            cardLeadingAnc.isActive = false
            cardTrailingAnc.isActive = false
            
            animatedView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: self.presenting ? 20 : self.originFrame.minY).isActive = true
            animatedView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: self.presenting ? 0 : self.originFrame.minX).isActive = true
            animatedView.trailingAnchor.constraint(equalTo: self.presenting ? containerView.trailingAnchor : containerView.leadingAnchor, constant: self.presenting ? 0 : self.originFrame.maxX).isActive = true
            
            containerView.layoutIfNeeded()
            animatedView.corners(!self.presenting)
            if !self.presenting {
                detailsContainer.isHidden = true
            }
        }) { (_) in
            if self.presenting {
                UIView.animate(withDuration: self.duration / 4.0, animations: {
                    topAnc.isActive = false
                    leadingAnc.isActive = false
                    trailingAnc.isActive = false
                    bottomAnc.isActive = false
                    
                    detailsContainer.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20).isActive = true
                    detailsContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0).isActive = true
                    detailsContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0).isActive = true
                    detailsContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0).isActive = true
                    
                    containerView.layoutIfNeeded()
                    toView.isHidden = false
                }, completion: { (_) in
                    animatedView.isHidden = true
                    transitionContext.completeTransition(true)
                })
            } else {
                self.originView.isHidden = false
                transitionContext.completeTransition(true)
            }
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
}
