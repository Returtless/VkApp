//
//  LikeCounterControl.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class LikeCounterControl: UIControl {
    var counterLabel = UILabel()
    var iconButton = UIButton()
    
    var countOfLikes : Int = 0
    var isLiked : Bool = false
    
    private let liked = "♥︎"
    private let unliked = "♡"
    
    override func layoutSubviews() {
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        iconButton.setTitle(isLiked ? liked : unliked, for: .normal)
        iconButton.titleLabel?.font = .systemFont(ofSize: CGFloat(15))
        iconButton.setTitleColor(isLiked ? .red : .black, for: .normal)
        iconButton.setTitleColor(.white, for: .selected)
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
        if isLiked {
            countOfLikes-=1
        } else {
            countOfLikes+=1
        }
        isLiked = !isLiked
        iconButton.setTitleColor(isLiked ? .red : .black, for: .normal)
        iconButton.setTitle(isLiked ? liked : unliked, for: .normal)
        counterLabel.text = String(countOfLikes)
    }
}
