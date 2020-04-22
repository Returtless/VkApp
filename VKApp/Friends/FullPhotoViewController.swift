//
//  FullPhotoViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 22.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FullPhotoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    let animator = FullPhotoAnimationDismissController(endFrame: CGRect(x: 0, y: 0, width: 300, height: 400))
    let photoInteractiveTransition = PhotoInteractiveTransition()
    
    var photo = Photo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.image = photo.image
        //transitioningDelegate = self
    }
}

class PhotoInteractiveTransition: UIPercentDrivenInteractiveTransition {
    var viewController: FullPhotoViewController? {
        didSet {
            let recognizer = UIPanGestureRecognizer(target: self,
                                                    action: #selector(handleScreenEdgeGesture(_:)))
            viewController?.view.addGestureRecognizer(recognizer)
        }
    }
    
    
    var hasStarted: Bool = false
    var shouldFinish: Bool = false
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            self.hasStarted = true
            self.viewController?.dismiss(animated: true)
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            let relativeTranslation = translation.y / (recognizer.view?.bounds.height ?? 1)
            let progress = max(0, min(1, relativeTranslation))
            
            self.shouldFinish = progress > 0.33
            
            self.update(progress)
        case .ended:
            self.hasStarted = false
            self.shouldFinish ? self.finish() : self.cancel()
        case .cancelled:
            self.hasStarted = false
            self.cancel()
        default: return
        }
    }
    
}


extension FullPhotoViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return photoInteractiveTransition
    }
}
