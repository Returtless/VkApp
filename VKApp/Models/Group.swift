//
//  User.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class Group {
    var name : String
    var avatar : UIImage?
    var countOfPeoples : Int = 100
    
    init(name : String, avatar : String) {
        self.name = name
        self.avatar = UIImage(named: avatar)
    }
    
}

extension Group : Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        lhs.name == rhs.name && lhs.avatar == rhs.avatar
    }
}
