//
//  AvatarView.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class AvatarView: UIImageView {
    var imageView = UIImageView()
    var shadowView = UIView()
    
    
    @IBInspectable var radius: CGFloat = 10 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var opacity: Float = 2 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var color: UIColor = .black {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureShadowView()
        configureImageView()
        
    }
    
    private func configureShadowView(){
        shadowView.layer.shadowColor = color.cgColor
        shadowView.layer.shadowPath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 50, height: 50), cornerRadius: frame.size.width / 2).cgPath
        shadowView.layer.shadowOffset = CGSize.zero
        shadowView.layer.shadowOpacity = opacity
        shadowView.layer.shadowRadius = radius
        addSubview(shadowView)
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        setConstraints(shadowView)
        
    }
    
    private func configureImageView(){
        let cornerRadius = frame.size.width / 2
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        setConstraints(imageView)
    }
    
    private func setConstraints(_ view : UIView){
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
}
