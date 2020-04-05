//
//  PhotoAlbumController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit



class PhotoAlbumController: UICollectionViewController {
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { photos.count }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! PhotoCollectionViewCell
        let currentPhoto = photos[indexPath.row]
        cell.photoImageView.image = currentPhoto.image
        cell.likeControl.countOfLikes = currentPhoto.countOfLikes
        cell.likeControl.isLiked = currentPhoto.liked
        return cell
    }
}

extension PhotoAlbumController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = (collectionView.frame.width - 50) / 2
        
        return CGSize(width: width, height: width)
    }
}
