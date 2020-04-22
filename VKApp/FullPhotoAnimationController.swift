//
//  FullPhotoAnimationController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 22.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FullPhotoAnimationController:  NSObject, UIViewControllerAnimatedTransitioning {
    
    private let originFrame: CGRect
    
    init(originFrame: CGRect) {
        self.originFrame = originFrame
    }
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .to),
            let snapshot = source.view.snapshotView(afterScreenUpdates: true) else {
                return
        }
        let destination = transitionContext.containerView
        source.view.isHidden = true
        destination.addSubview(source.view)
        
        //вроде устанавливаю размер исходного фрейма, но потом при увеличении он уменьшается почемуто
        //возможно связано с модальным контроллером
        snapshot.frame = self.originFrame

        destination.addSubview(snapshot)
        
        UIView.animate(withDuration: 1, animations: {
            snapshot.frame = (transitionContext.finalFrame(for: source))
        }, completion: { success in
            source.view.isHidden = false
            snapshot.removeFromSuperview()
            transitionContext.completeTransition(true)
        })
    }
}


class FullPhotoAnimationDismissController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let endFrame: CGRect
    
    init(endFrame: CGRect) {
        self.endFrame = endFrame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let source = transitionContext.viewController(forKey: .from),
            let destination = transitionContext.viewController(forKey: .to),
            let snapshot = source.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(destination.view)
        containerView.addSubview(snapshot)
        source.view.isHidden = true
        
        UIView.animate(withDuration: 1, animations: {
            snapshot.frame = self.endFrame
        }, completion: { success in
            source.view.isHidden = false
            snapshot.removeFromSuperview()
            source.removeFromParent()
            if transitionContext.transitionWasCancelled {
                destination.view.removeFromSuperview()
            }
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
        
    }
}
