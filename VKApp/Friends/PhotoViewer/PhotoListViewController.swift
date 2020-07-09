//
//  PhotoListViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 17.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class PhotoListViewController: UIViewController {
    var userId = 0
    var photos : Results<Photo>?{
        didSet{
            imageView.photos = photos
            if let unwrappedArray = photos, !unwrappedArray.isEmpty{
                if let photo = unwrappedArray[0].getPhotoBigSize() {
                    imageView.image = photo
                }
            }
        }
    }
    var newsPhoto : UIImage?
    let photoInteractiveTransition = PhotoInteractiveTransition()
    
    @IBOutlet var imageView: PhotoListImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if userId != 0 {
            photos = RealmService.getData(for:("ownerID", "==", "Int"), with: userId)
            DataService.getAllPhotosForUser(userId: userId,
                                            completion: {
                                                [weak self] array in
                                                self?.photos = array
                }
            )
        }
        if let newsPhoto = newsPhoto {
            imageView.image = newsPhoto
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "openFullPhotoOnViewSegue" {
            let photoVC = segue.destination as! FullPhotoViewController
            photoVC.photo = photos![imageView.activePhotoIndex]
            photoVC.transitioningDelegate = self
            self.photoInteractiveTransition.viewController = photoVC
        }
    }
    
    @objc func onTap(_ recognizer: UIPanGestureRecognizer) {
        if newsPhoto == nil {
            performSegue(withIdentifier: "openFullPhotoOnViewSegue", sender: self)
        }
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

