//
//  User.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import RealmSwift

class Group: Object, Codable {
    @objc dynamic var id: Int
    @objc dynamic var name, screenName: String
    @objc dynamic var isClosed: Int
    @objc dynamic var type: String
    @objc dynamic var isAdmin, isMember, isAdvertiser: Int
    @objc dynamic var photo50, photo100, photo200: String
    
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
    
    override static func primaryKey() -> String? {
        return "id"
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
