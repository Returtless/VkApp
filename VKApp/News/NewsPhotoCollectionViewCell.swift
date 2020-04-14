//
//  NewsPhotoCollectionViewCell.swift
//  VKApp
//
//  Created by Владислав Лихачев on 10.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NewsPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView! {
        didSet{
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
            photoImageView.isUserInteractionEnabled = true
            photoImageView.addGestureRecognizer(tapGestureRecognizer)
        }
    }
    weak var delegate: NewsPhotoCollectionViewDelegate?
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        delegate!.onButtonTapped(photoImageView.image!)
    }
}





