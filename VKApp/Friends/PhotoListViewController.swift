//
//  PhotoListViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 17.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class PhotoListViewController: UIViewController {
    
    var photos = [Photo]()
        let photoInteractiveTransition = PhotoInteractiveTransition()
    
    @IBOutlet weak var imageView: PhotoListImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.photos = photos
        imageView.image = photos[0].image
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segue.destination.transitioningDelegate = self
        if segue.identifier == "openFullPhotoOnViewSegue" {
            let photoVC = segue.destination as! FullPhotoViewController
            photoVC.photo = photos[imageView.activePhotoIndex]
            photoVC.transitioningDelegate = self
             self.photoInteractiveTransition.viewController = photoVC
        }
    }
    
    @objc func onTap(_ recognizer: UIPanGestureRecognizer) {
        performSegue(withIdentifier: "openFullPhotoOnViewSegue", sender: self)
    }
}

class PhotoListImageView : UIImageView {
    var photos = [Photo]()
    private var popupOffset: CGFloat {
        return self.frame.width + 100
    }
    
    var activePhotoIndex = 0
    
    var interactiveAnimator: UIViewPropertyAnimator!
    
    private var animationProgress: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        self.addGestureRecognizer(recognizer)
        
        
    }
    //направление свайпа
    var swipeToLeft = 0
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            swipeToLeft = recognizer.translation(in: self).x > 0 ? 1 : -1
            initAnimator(CGFloat(swipeToLeft))
        case .changed:
            let translation = recognizer.translation(in: self)
            var fraction = CGFloat(swipeToLeft) * translation.x / popupOffset
            if interactiveAnimator.isReversed { fraction *= -1 }
            interactiveAnimator.fractionComplete = fraction + animationProgress
            print("\(recognizer.translation(in: self).x)   \(recognizer.velocity(in: self).x)  \(swipeToLeft)  \(fraction)")
        case .ended:
            
            let shouldComplete = recognizer.velocity(in: self).x > 0
            let lastPhoto = swipeToLeft == 1 && activePhotoIndex==photos.count-1 //фотография последняя при свайпе вправо
            let firstPhoto = swipeToLeft != 1 && activePhotoIndex==0 //фотография первая при свайпе влево
            var reversedWasChanged = false
            
            //если мы вдруг начинаем вести пальцем в другую сторону от изначального направления
            //или это первое или последнее фото, а также если процент анимации меньше 60, то реверсируем анимацию
            if ((!shouldComplete && swipeToLeft == 1) || (swipeToLeft != 1 && shouldComplete))
                && !interactiveAnimator.isReversed
                || lastPhoto || firstPhoto
                || interactiveAnimator.fractionComplete.isLess(than: 0.6) {
                interactiveAnimator.isReversed.toggle()
                reversedWasChanged = true
            }
            
            if !reversedWasChanged{
                interactiveAnimator.stopAnimation(true)
                if swipeToLeft == 1 && !lastPhoto { activePhotoIndex+=1 }
                else if swipeToLeft != 1 && !firstPhoto { activePhotoIndex-=1 }
                
                image = photos[activePhotoIndex].image
                
                self.layer.opacity = 0
                self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                
                interactiveAnimator.addAnimations({
                    self.transform = .identity
                    self.layer.opacity = 1
                })
                
                interactiveAnimator.startAnimation()
            } else {
                interactiveAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            }
        default: break
        }
    }
    
    
    
    func initAnimator(_ swipeToLeft : CGFloat){
        interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .linear)
        interactiveAnimator.addAnimations(
            {
                self.transform = CGAffineTransform(translationX: swipeToLeft * (self.popupOffset), y: 0)
            }
        )
        interactiveAnimator?.startAnimation()
        animationProgress = interactiveAnimator.fractionComplete
        interactiveAnimator.pauseAnimation()
    }
}

extension PhotoListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FullPhotoAnimationDismissController(endFrame: imageView.frame)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return FullPhotoAnimationController(originFrame: imageView.frame)
    }
}


