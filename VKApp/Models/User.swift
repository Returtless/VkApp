//
//  User.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import RealmSwift

class User: Object, Decodable {
    @objc dynamic var canAccessClosed: Bool = true
    @objc dynamic var domain: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var id: Int = 0
    @objc dynamic var isClosed: Bool = true
    @objc dynamic var lastName:  String = ""
    @objc dynamic var nickname: String = ""
    @objc dynamic var online: Int = 0
    @objc dynamic var photo100 = "photo_100"
    @objc dynamic var sex: Int = 0
    @objc dynamic var trackCode: String = ""
    
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
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class UserItems : Decodable {
    var count : Int = 0
    var items : [User] = []
}


class ResponseUsers : Decodable {
    var response : UserItems = UserItems()
}
