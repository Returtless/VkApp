//
//  User.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

//class Group {
//    var name : String
//    var avatar : UIImage?
//    var countOfPeoples : Int = 100
//
//    init(name : String, avatar : String) {
//        self.name = name
//        let img = !avatar.isEmpty ? UIImage(named: avatar) : UIImage.init(systemName: "nosign")
//        self.avatar = img
//    }
//
//}
//
//extension Group : Equatable {
//    static func == (lhs: Group, rhs: Group) -> Bool {
//        lhs.name == rhs.name && lhs.avatar == rhs.avatar
//    }
//}

class Group: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: String
    let isAdmin, isMember, isAdvertiser: Int
    let photo50, photo100, photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

class GroupItems : Decodable {
    
    private enum CodingKeys: String, CodingKey { case count
        case items }
    
    var count : Int64 = 0
    var items : [Group] = []
}


class ResponseGroups : Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case response }
    
    var response : GroupItems = GroupItems()
}
