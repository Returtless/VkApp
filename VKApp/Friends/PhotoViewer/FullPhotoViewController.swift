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
    let animator = FullPhotoAnimationDismissController(endFrame: CGRect(x: 0,
                                                                        y: 0,
                                                                        width: 300,
                                                                        height: 400))
    let photoInteractiveTransition = PhotoInteractiveTransition()
    
    var photo : Photo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        imageView.isUserInteractionEnabled = true
        imageView.image = photo?.getPhotoBigSize()
        let height = self.view.frame.width * 4 / 3
        imageView.frame = CGRect(x: 0,
                                 y: self.view.frame.height / 2 - height / 2,
                                 width: self.view.frame.width,
                                 height: height)
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
    var interactiveAnimator: UIViewPropertyAnimator!
    
    private var animationProgress: CGFloat = 0
    
    @objc func handleScreenEdgeGesture(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            initAnimator()
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            var fraction = translation.y / (self.viewController?.imageView.frame.height)!
            
            if interactiveAnimator.isReversed { fraction *= -1 }//смена направления если анимация стала реверсивная
            
            interactiveAnimator.fractionComplete = fraction + animationProgress
            
            //завершаем анимацию, если комплит больше 50%
            if (!interactiveAnimator.fractionComplete.isLess(than: 0.5)){
                recognizer.state = .ended
            }
        case .ended:
            var reversedWasChanged = false // флаг для понимания вернулась анимация в начало или нужно закончить
            if recognizer.velocity(in: recognizer.view).y <= 0 && !interactiveAnimator.isReversed
            {
                interactiveAnimator.isReversed.toggle()
                reversedWasChanged.toggle()
            }
            if (!reversedWasChanged){
                interactiveAnimator.stopAnimation(true)
                interactiveAnimator.finishAnimation(at: .current)
                self.viewController?.dismiss(animated: true)
                self.finish()
            } else {
                interactiveAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
                self.cancel()
            }
        case .cancelled:
            self.cancel()
        default: return
        }
    }
    func initAnimator(){
        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        interactiveAnimator.addAnimations(
            {[weak self] in
                self!.viewController?.imageView.transform = CGAffineTransform(
                    translationX: 0,
                    y: (self!.viewController?.imageView.frame.height)!)
            }
        )
        interactiveAnimator?.startAnimation()
        animationProgress = interactiveAnimator.fractionComplete
        interactiveAnimator.pauseAnimation()
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
