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
        guard let destination = transitionContext.viewController(forKey: .to) as? FullPhotoViewController,
            let fromVC = (transitionContext.viewController(forKey: .from)!.children.first as? CustomNavigationController)?.children.last as? PhotoListViewController,
            let snapshot = fromVC.imageView.snapshotView(afterScreenUpdates: false) else {
                return
        }
        let containerView = transitionContext.containerView
        destination.view.isHidden = true
        containerView.addSubview(destination.view)
        snapshot.frame = self.originFrame
        containerView.addSubview(snapshot)
        
        //высота изображения на вью на который переходим, нужно рассчитать для сохранения соотношения строн в изображении 4/3
        let destImageHeight = snapshot.frame.height * (destination.imageView.frame.width/snapshot.frame.width)
        
        UIView.animate(withDuration: 1, animations: {
            //сделал так, чтобы снапшот занял ту же позицию и тот же размер что и имеджвью
            snapshot.frame = CGRect(x: 0,
                                    y: containerView.frame.height/2-destImageHeight/2,
                                    width: destination.imageView.frame.width,
                                    height: destImageHeight)
        }, completion: { success in
            destination.view.isHidden = false
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
        guard let source = transitionContext.viewController(forKey: .from) as? FullPhotoViewController,
            let destination = transitionContext.viewController(forKey: .to),
            let snapshot = source.imageView.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        //я хотел скрыть изображение на экране на который мы возвращаемся, получив экрна таким образом
        //let destination = (transitionContext.viewController(forKey: .to)!.children.first as? CustomNavigationController)?.children.last as? PhotoListViewController
        //но судя по всему так не работает, потому что полностью пропадает вью с навигейшн контроллера, так как при просмотре вью иерархии там остался только навигейшн, а PhotoListViewController не оказалось
        //хотелось бы понять как можно скрыть изображение с PhotoListViewController при переходе на него этим аниматором
        source.view.frame = source.imageView.frame
        let containerView = transitionContext.containerView
        containerView.addSubview(destination.view)
        containerView.addSubview(snapshot)
        
        snapshot.frame = source.imageView.frame
        source.view.isHidden = true
        destination.view.isHidden = true
        UIView.animate(withDuration: 1, animations: {
            snapshot.frame = self.endFrame
        }, completion: { success in
            source.view.isHidden = false
            snapshot.removeFromSuperview()
            source.removeFromParent()
            destination.view.isHidden = false
            if transitionContext.transitionWasCancelled {
                destination.view.removeFromSuperview()
            }
            transitionContext.completeTransition(true)
        })
        
    }
}
