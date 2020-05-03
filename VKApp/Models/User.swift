//
//  User.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class User: Decodable {
    var canAccessClosed: Bool = true
    var domain: String = ""
    var firstName: String = ""
    var id: Int = 0
    var isClosed: Bool = true
    var lastName:  String = ""
    var nickname: String = ""
    var online: Int = 0
    var photo100 = "photo_100"
    var sex: Int = 0
    var trackCode: String = ""
    
    enum CodingKeys: String, CodingKey {
        case canAccessClosed = "can_access_closed"
        case domain
        case firstName = "first_name"
        case id
        case isClosed = "is_closed"
        case lastName = "last_name"
        case photo100 = "photo_100"
        case nickname, online
        case sex
        case trackCode = "track_code"
    }
    
    func getFullName() -> String {
        "\(self.firstName) \(self.lastName)"
    }
}

class UserItems : Decodable {
    
    private enum CodingKeys: String, CodingKey { case count
        case items = "items" }
    
    var count : Int = 0
    var items : [User] = []
}


class ResponseUsers : Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case response }
    
    var response : UserItems = UserItems()
}
