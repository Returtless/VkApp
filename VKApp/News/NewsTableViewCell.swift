//
//  NewsTableViewCell.swift
//  VKApp
//
//  Created by Владислав Лихачев on 09.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarView: AvatarView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var createDateLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var likeCounterControl: LikeCounterControl!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    @IBOutlet weak var viewsCounter: UILabel!
    
    @IBOutlet weak var commentsCounter: CommentCounterControl!
    
    var photos = [UIImage]()
    
    weak var delegate: CommentCounterDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        messageLabel.sizeToFit()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        photoCollectionView.isUserInteractionEnabled = true
        photoCollectionView.reloadData()
        
        commentsCounter.delegate = self
        
    }
    
    
}
extension NewsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { photos.count }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as! NewsPhotoCollectionViewCell
        cell.photoImageView.image = photos[indexPath.row]
        cell.isUserInteractionEnabled = true
        cell.delegate = self
        return cell
    }
    
}

extension NewsTableViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = collectionView.frame.width / 2
        return CGSize(width: width, height: width)
    }
}

protocol CommentCounterDelegate: class {
    func onButtonTapped()
}

protocol NewsPhotoCollectionViewDelegate: class {
    func onButtonTapped(_ data : UIImage)
}

extension NewsTableViewCell : CommentCounterDelegate {
    func onButtonTapped(){
        delegate!.onButtonTapped()
    }
}
extension NewsTableViewCell : NewsPhotoCollectionViewDelegate {
    func onButtonTapped(_ data : UIImage){
        delegate!.onButtonTapped()
    }
}
