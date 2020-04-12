//
//  LikeCounterControl.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class CommentCounterControl: UIControl {
    var counterLabel = UILabel()
    var iconButton: UIButton = {
        let iconButton = UIButton()
        iconButton.setImage(UIImage(systemName: "message"), for: .normal)
        iconButton.addTarget(self, action: #selector(changeCounter(_:)), for: .touchUpInside)
        return iconButton
    }()
    
    var countOfComments : Int = 0
    var isLiked : Bool = false

    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        counterLabel.text = String(countOfComments)
        counterLabel.font = .systemFont(ofSize: CGFloat(20))
        
        let stack = UIStackView()
        stack.addArrangedSubview(counterLabel)
        stack.addArrangedSubview(iconButton)
        counterLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            counterLabel.trailingAnchor.constraint(equalTo: iconButton.leadingAnchor)
        ])
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
            countOfComments-=1
        } else {
            countOfComments+=1
        }
        isLiked.toggle()
        counterLabel.text = String(countOfComments)
    }
}
