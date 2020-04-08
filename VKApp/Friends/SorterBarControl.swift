//
//  SorterBarControl.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class SorterBarControl: UIControl {
    var letters = [String]() {
        didSet{
            if oldValue != letters{
                setupView()
            }
        }
    }
    var choosedLetter = ""
    
    private var letterButtons = [UIButton]()
    private var stackView = UIStackView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func awakeFromNib() {
           super.awakeFromNib()
           
       }
    
    func setupView() {
        letterButtons.removeAll()
        for letter in letters {
            let button = UIButton(type: .system)
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
            self.letterButtons.append(button)
        }
        stackView.removeFromSuperview()
        stackView = UIStackView(arrangedSubviews: self.letterButtons)
        
        self.addSubview(stackView)
        stackView.spacing = 1
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
    }
    
    @objc private func selectLetter(_ sender: UIButton) {
        if let index = letterButtons.firstIndex(of: sender){
            choosedLetter = letters[index]
            sendActions(for: .valueChanged)
        }
    }
}
