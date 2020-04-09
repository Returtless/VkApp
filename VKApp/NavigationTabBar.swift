//
//  NavigationTabBar.swift
//  VKApp
//
//  Created by Владислав Лихачев on 07.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NavigationTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        setTabBarItems()
    }
    func setTabBarItems(){
        
        self.tintColor = .white
        self.unselectedItemTintColor = .darkGray
        
        let myTabBarItem1 = (items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(systemName: "person.fill")?.withRenderingMode(UIImage.RenderingMode.automatic)
        myTabBarItem1.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        myTabBarItem1.title = "Друзья"
        myTabBarItem1.badgeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        
        let myTabBarItem2 = (items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(systemName: "person.3.fill")?.withRenderingMode(UIImage.RenderingMode.automatic)
        myTabBarItem2.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        myTabBarItem2.title = "Группы"
        
        let myTabBarItem3 = (items?[2])! as UITabBarItem
               myTabBarItem3.image = UIImage(systemName: "house.fill")?.withRenderingMode(UIImage.RenderingMode.automatic)
               myTabBarItem3.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
               myTabBarItem3.title = "Новости"
    }
}
