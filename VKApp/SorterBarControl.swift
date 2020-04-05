//
//  SorterBarControl.swift
//  VKApp
//
//  Created by Владислав Лихачев on 04.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class SorterBarControl: UIControl {
    var letters = [String]()
    private var letterButtons = [UIButton]()
    var stackView = UIStackView()
    
    override func layoutSubviews() {
        setupView()
    }
    
    func setupView() {
        for letter in letters {
            let button = UIButton(type: .system)
            button.setTitle(letter, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.white, for: .selected)
            button.frame = CGRect(x: 0, y: 0, width: 15, height: 10)
            button.addTarget(self, action: #selector(selectLetter(_:)), for: .touchUpInside)
            self.letterButtons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.letterButtons)
        
        self.addSubview(stackView)
        stackView.frame = CGRect(x: 0, y: 0, width: 20, height: 100)
        stackView.spacing = 8
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        contentVerticalAlignment = .fill
    }
    
    @objc private func selectLetter(_ sender: UIButton) {
       // guard let index = self.buttons.index(of: sender) else { return }
        //guard let day = Day(rawValue: index) else { return }
        //self.selectedDay = day
    }

}
