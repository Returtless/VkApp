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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(iconButton)
        NSLayoutConstraint.activate([
            iconButton.topAnchor.constraint(equalTo: topAnchor),
            iconButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        setupView()
        addSubview(iconButton)
        NSLayoutConstraint.activate([
            iconButton.topAnchor.constraint(equalTo: topAnchor),
            iconButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            iconButton.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func setupView() {
        iconButton.setTitle("♡", for: .normal)
        iconButton.setTitleColor(.lightGray, for: .normal)
        iconButton.setTitleColor(.white, for: .selected)
    }
    
}
