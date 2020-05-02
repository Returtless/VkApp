//
//  Friend.swift
//  VKApp
//
//  Created by Владислав Лихачев on 02.05.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//
//   let friend = try? newJSONDecoder().decode(Friend.self, from: jsonData)

import Foundation

// MARK: - Friend
class Friend: Decodable {
     var canAccessClosed: Bool = true
     var domain: String = ""
     var firstName: String = ""
     var id: Int64 = 0
     var isClosed: Bool = true
     var lastName:  String = ""
     var nickname: String = ""
     var online: Int64 = 0
     var sex: Int64 = 0
     var trackCode: String = ""

    enum CodingKeys: String, CodingKey {
        case canAccessClosed = "can_access_closed"
        case domain
        case firstName = "first_name"
        case id
        case isClosed = "is_closed"
        case lastName = "last_name"
        case nickname, online
        case sex
        case trackCode = "track_code"
    }
}

// MARK: - City

class FriendItems : Decodable {

    private enum CodingKeys: String, CodingKey { case count
        case items = "items" }

    var count : Int64 = 0
    var items : [Friend] = []
}


class ResponseFriends : Decodable {

    private enum CodingKeys: String, CodingKey {
        case response }

    var response : FriendItems = FriendItems()
}
