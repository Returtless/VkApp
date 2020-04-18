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
    var activePhotoIndex = 0
    
    @IBOutlet weak var imageView: PhotoListImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.photos = photos
        imageView.image = photos[0].image
        
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
    
    
    @objc func onPan(_ recognizer: UIPanGestureRecognizer) {
        let velocity = recognizer.velocity(in: self).x > 0 ? 1 : -1
        switch recognizer.state {
        case .began:
            interactiveAnimator = UIViewPropertyAnimator(duration: 1, curve: .easeInOut)
            interactiveAnimator.addAnimations(
                {
                    self.transform = CGAffineTransform(translationX: CGFloat(velocity) * (self.popupOffset), y: 0)
                }
            )
            interactiveAnimator?.startAnimation()
            animationProgress = interactiveAnimator.fractionComplete
            interactiveAnimator.pauseAnimation()
        case .changed:
            let translation = recognizer.translation(in: self)
            
            let fraction = CGFloat(velocity) * translation.x / popupOffset
            
            interactiveAnimator.fractionComplete = fraction + animationProgress
        case .ended:
            
            interactiveAnimator.stopAnimation(true)
            if velocity == 1 && activePhotoIndex<photos.count-1 {
                activePhotoIndex+=1
                image = photos[activePhotoIndex].image
            }
            else if velocity != 1 && activePhotoIndex>0 {
                activePhotoIndex-=1
                image = photos[activePhotoIndex].image
            }
            
            self.layer.opacity = 0
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            interactiveAnimator.addAnimations({
                self.transform = .identity
                self.layer.opacity = 1
            })
            
            interactiveAnimator.startAnimation()
            
        default: return
        }
    }
    
}
