//
//  LikeCounterControl.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class LikeCounterControl: UIControl {
    var countOfLikes : UInt = 0
    var like : Bool = false
    var counterLabel = UILabel()
    var iconButton = UIButton()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        iconButton.tintColor = like ? .red : .white
        iconButton.setImage(UIImage(named: "heart"), for: .normal)
        iconButton.addTarget(self, action: #selector(changeCounter(_:)), for: .touchUpInside)
        
        counterLabel.text = String(countOfLikes)
        counterLabel.font = .boldSystemFont(ofSize: CGFloat(9))
        
        let stack = UIStackView()
        stack.addArrangedSubview(counterLabel)
        stack.addArrangedSubview(iconButton)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    @objc private func changeCounter(_ sender: UIButton) {
        if like {
            countOfLikes-=1
            sender.tintColor = .white
        } else {
            countOfLikes+=1
            sender.tintColor = .red
        }
        like = !like
        counterLabel.text = String(countOfLikes)
    }
}
