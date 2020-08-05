//
//  SimpleUser.swift
//  VKApp
//
//  Created by Владислав Лихачев on 05.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class SimpleUser {
    var firstName: String = ""
    var id: Int = 0
    var lastName:  String = ""
    var nickname: String = ""
    var online: Int = 0
    var photo100 = ""
    var sex: Int = 0
    
    internal init(firstName: String = "", id: Int = 0, lastName: String = "", nickname: String = "", online: Int = 0, photo100: String = "", sex: Int = 0) {
        self.firstName = firstName
        self.id = id
        self.lastName = lastName
        self.nickname = nickname
        self.online = online
        self.photo100 = photo100
        self.sex = sex
    }
}
