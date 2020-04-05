//
//  TabBarViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        
        setTabBarItems()
    }
    
    func setTabBarItems(){
        
        let myTabBarItem1 = (self.tabBar.items?[0])! as UITabBarItem
        myTabBarItem1.image = UIImage(named: "friendsIcon")?.withRenderingMode(UIImage.RenderingMode.automatic)
        myTabBarItem1.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        myTabBarItem1.title = nil
        myTabBarItem1.badgeColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        
        let myTabBarItem2 = (self.tabBar.items?[1])! as UITabBarItem
        myTabBarItem2.image = UIImage(named: "groupsIcon")?.withRenderingMode(UIImage.RenderingMode.automatic)
        myTabBarItem2.image?.withTintColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
        myTabBarItem2.title = nil
    }
    
}
