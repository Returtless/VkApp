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
        
        let myTabBarItem1 = (items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "friendsIcon")?.withRenderingMode(UIImage.RenderingMode.automatic)
        myTabBarItem1.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        myTabBarItem1.title = nil
        myTabBarItem1.badgeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        let myTabBarItem2 = (items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "groupsIcon")?.withRenderingMode(UIImage.RenderingMode.automatic)
        myTabBarItem2.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        myTabBarItem2.title = nil
    }
}
