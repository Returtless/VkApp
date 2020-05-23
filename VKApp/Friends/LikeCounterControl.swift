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
    var iconButton: UIButton = {
        let iconButton = UIButton()
        iconButton.setImage(UIImage(systemName: "heart"), for: .normal)
        iconButton.addTarget(self, action: #selector(changeCounter(_:)), for: .touchUpInside)
        return iconButton
    }()
    
    var countOfLikes : Int = 0
    var isLiked : Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    private func setupView() {
        backgroundColor = .clear
        iconButton.setImage(UIImage(systemName: isLiked ? "heart.fill": "heart"), for: .normal)
        iconButton.tintColor = isLiked ? .red : .blue
        
        counterLabel.text = String(countOfLikes)
        counterLabel.adjustsFontSizeToFitWidth = true
        counterLabel.minimumScaleFactor = 0.5
        //counterLabel.font = .systemFont(ofSize: CGFloat(20))
        
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
        self.reloadInputViews()
    }
    
    @objc private func changeCounter(_ sender: UIButton) {
        if isLiked {
            countOfLikes-=1
        } else {
            countOfLikes+=1
        }
        isLiked.toggle()
        iconButton.setImage(UIImage(systemName: isLiked ? "heart.fill": "heart"), for: .normal)
        iconButton.tintColor = isLiked ? .red : UIColor(named: "VK")
        UIView.transition(with: counterLabel,
                          duration: 0.75,
                          options: .transitionFlipFromTop,
                          animations: {
                            //нужно отключить возможность нажатия на кнопку, пока идет анимация и вернуть после окончания
                            self.iconButton.isUserInteractionEnabled = false
                            self.counterLabel.text = String(self.countOfLikes)
        }, completion : { _ in
            self.iconButton.isUserInteractionEnabled = true
        })
        
    }
}
