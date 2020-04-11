//
//  LikeCounterControl.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class ShareCounterControl: UIControl {
    var counterLabel = UILabel()
    var iconButton: UIButton = {
        let iconButton = UIButton()
        iconButton.setImage(UIImage(systemName: "arrow.up.right.circle"), for: .normal)
        iconButton.addTarget(self, action: #selector(changeCounter(_:)), for: .touchUpInside)
        return iconButton
    }()
    
    var countOfShares : Int = 0
    var isLiked : Bool = false
    
    private let liked = "♥︎"
    private let unliked = "♡"
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        counterLabel.text = String(countOfShares)
        counterLabel.font = .boldSystemFont(ofSize: CGFloat(14))
        
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
            countOfShares-=1
        } else {
            countOfShares+=1
        }
        isLiked.toggle()
        
        //iconButton.setTitleColor(isLiked ? .red : .black, for: .normal)
        //iconButton.setTitle(isLiked ? liked : unliked, for: .normal)
        counterLabel.text = String(countOfShares)
    }
}
