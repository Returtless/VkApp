//
//  FriendsSearchBar.swift
//  VKApp
//
//  Created by Владислав Лихачев on 08.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsSearchBar: UISearchBar {
    var hiddenView = UIView()
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        //если указать делегатом самого себя то поиск ломается, но будет работать searchBarShouldBeginEditing для тапа по бару,
        //чтобы обойти использовал невидимую  view для тапа
        //self.delegate = self
        addHiddenViewForTap()
        
    }
    
    @objc func searchWasTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        
        // не удалось анимировать полученную imageView с лупой
        //    if let textfield = self.value(forKey: "searchField") as? UITextField {
        
        //        if let glassIconView = textfield.leftView as? UIImageView {
        //            let animation = CASpringAnimation(keyPath: "position.x")
        //            animation.fromValue = self.frame.width / 2
        //            animation.toValue = 10
        //            animation.duration = 3
        //            animation.fillMode = .forwards
        //            glassIconView.layer.add(animation, forKey: nil)
        //        }
        //    }
        self.setPositionAdjustment(.init(horizontal: 0, vertical: 0), for: .search)
        self.setShowsCancelButton(true, animated: true)
        //на кнопку отмены добавил гестуру для сброса бара в начальное положение
        if let cancelButton = self.value(forKey: "cancelButton") as? UIButton {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelButtonWasTapped(tapGestureRecognizer:)))
            cancelButton.addGestureRecognizer(tapGestureRecognizer)
        }
        becomeFirstResponder()
        hiddenView.removeFromSuperview()
    }
    
    func addHiddenViewForTap(){
        hiddenView = UIView()
        hiddenView.backgroundColor = .clear
        self.addSubview(hiddenView)
        hiddenView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hiddenView.topAnchor.constraint(equalTo: topAnchor),
            hiddenView.leadingAnchor.constraint(equalTo: leadingAnchor),
            hiddenView.bottomAnchor.constraint(equalTo: bottomAnchor),
            hiddenView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchWasTapped(tapGestureRecognizer:)))
        hiddenView.addGestureRecognizer(tapGestureRecognizer)
        self.setPositionAdjustment(.init(horizontal: self.frame.width / 2 - 20, vertical: 0), for: .search)
    }
    @objc func cancelButtonWasTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.text = ""
        self.setShowsCancelButton(false, animated: true)
        self.endEditing(true)
        addHiddenViewForTap()
    }
}

//extension FriendsSearchBar : UISearchBarDelegate {
//    func cancelButtonWasTapped(_ searchBar: UISearchBar) {
//        searchBar.text = ""
//        self.setShowsCancelButton(false, animated: true)
//        searchBar.endEditing(true)
//        self.setPositionAdjustment(.init(horizontal: self.frame.width / 2, vertical: 0), for: .search)
//        addHiddenViewForTap()
//    }
//
//    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.setShowsCancelButton(true, animated: true)
//        UIView.animate(
//            withDuration: 1,
//            animations: {
//
//                self.setPositionAdjustment(.init(horizontal: 0, vertical: 0), for: .search)
//
//        })
//        return true
//    }
//}
