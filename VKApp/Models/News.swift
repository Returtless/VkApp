//
//  News.swift
//  VKApp
//
//  Created by Владислав Лихачев on 09.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import Alamofire

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let news = try? newJSONDecoder().decode(News.self, from: jsonData)

import Foundation

// MARK: - News
class ResponseNews: Decodable {
    var response: NewsItems

    init(response: NewsItems) {
        self.response = response
    }
}

// MARK: - Response
class NewsItems: Decodable {
    var items: [News]
    var Users: [User]
    var groups: [Group]
    var nextFrom: String

    enum CodingKeys: String, CodingKey {
        case items, Users, groups
        case nextFrom = "next_from"
    }

    init(items: [News], Users: [User], groups: [Group], nextFrom: String) {
        self.items = items
        self.Users = Users
        self.groups = groups
        self.nextFrom = nextFrom
    }
}


// MARK: - Item
class News: Decodable {
    var canDoubtCategory, canSetCategory: Bool
    var type: String
    var sourceID, date: Int
    var postType, text: String
    var signerID, markedAsAds: Int
    var attachments: [Attachment]
    var postSource: PostSource
    var comments: Comments
    var LikesNews: LikesNews
    var RepostsNews: RepostsNews
    var views: Views
    var isFavorite: Bool
    var postID: Int

    enum CodingKeys: String, CodingKey {
        case canDoubtCategory = "can_doubt_category"
        case canSetCategory = "can_set_category"
        case type
        case sourceID = "source_id"
        case date
        case postType = "post_type"
        case text
        case signerID = "signer_id"
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, LikesNews, RepostsNews, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
    }

    init(canDoubtCategory: Bool, canSetCategory: Bool, type: String, sourceID: Int, date: Int, postType: String, text: String, signerID: Int, markedAsAds: Int, attachments: [Attachment], postSource: PostSource, comments: Comments, LikesNews: LikesNews, RepostsNews: RepostsNews, views: Views, isFavorite: Bool, postID: Int) {
        self.canDoubtCategory = canDoubtCategory
        self.canSetCategory = canSetCategory
        self.type = type
        self.sourceID = sourceID
        self.date = date
        self.postType = postType
        self.text = text
        self.signerID = signerID
        self.markedAsAds = markedAsAds
        self.attachments = attachments
        self.postSource = postSource
        self.comments = comments
        self.LikesNews = LikesNews
        self.RepostsNews = RepostsNews
        self.views = views
        self.isFavorite = isFavorite
        self.postID = postID
    }
    
    func getAuthorInfo() -> Group?{
//        let params: Parameters = [
//            "group_id": abs(self.sourceID)
//        ]
//        var group : Group? = nil
//        DataService.getServerData(
//            method: DataService.Methods.getGroupById,
//            with: params,
//            typeName: Group.self,
//            completion: {
//                array in
//                group = (array as! [Group])[0]
//            }
//        )
//        return group!
        return nil
    }
}

// MARK: - Attachment
class Attachment: Decodable {
    var type: String
    var photo: PhotoNews

    init(type: String, photo: PhotoNews) {
        self.type = type
        self.photo = photo
    }
}

// MARK: - Photo
class PhotoNews: Decodable {
    var id, albumID, ownerID, userID: Int
    var sizes: [Size]
    var text: String
    var date: Int
    var lat, long: Double
    var accessKey: String

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case sizes, text, date, lat, long
        case accessKey = "access_key"
    }

    init(id: Int, albumID: Int, ownerID: Int, userID: Int, sizes: [Size], text: String, date: Int, lat: Double, long: Double, accessKey: String) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.sizes = sizes
        self.text = text
        self.date = date
        self.lat = lat
        self.long = long
        self.accessKey = accessKey
    }
}


// MARK: - Comments
class Comments: Decodable {
    var count, canPost: Int

    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }

    init(count: Int, canPost: Int) {
        self.count = count
        self.canPost = canPost
    }
}

// MARK: - LikesNews
class LikesNews: Decodable {
    var count, userLikes, canLike, canPublish: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }

    init(count: Int, userLikes: Int, canLike: Int, canPublish: Int) {
        self.count = count
        self.userLikes = userLikes
        self.canLike = canLike
        self.canPublish = canPublish
    }
}

// MARK: - PostSource
class PostSource: Decodable {
    var type, platform: String

    init(type: String, platform: String) {
        self.type = type
        self.platform = platform
    }
}

// MARK: - RepostsNews
class RepostsNews: Decodable {
    var count, userReposted: Int

    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }

    init(count: Int, userReposted: Int) {
        self.count = count
        self.userReposted = userReposted
    }
}

// MARK: - Views
class Views: Decodable {
    var count: Int

    init(count: Int) {
        self.count = count
    }
}

// MARK: - OnlineInfo
class OnlineInfo: Decodable {
    var visible: Bool
    var isOnline: Bool?
    var appID: Int?
    var isMobile: Bool?

    enum CodingKeys: String, CodingKey {
        case visible
        case isOnline = "is_online"
        case appID = "app_id"
        case isMobile = "is_mobile"
    }

    init(visible: Bool, isOnline: Bool?, appID: Int?, isMobile: Bool?) {
        self.visible = visible
        self.isOnline = isOnline
        self.appID = appID
        self.isMobile = isMobile
    }
}

//class News1{
//
//    var author : User
//    var createDate : Date
//    var text : String
//    var photos : [UIImage]
//    var comments : [Comment]
//    var likesCount : Int
//    var viewsCount : Int
//
//    init(author : User, text : String, photos : [String], comments : [Comment]) {
//        self.author = author
//        self.createDate = Date.init()
//        self.text = text
//        self.photos = photos.map({UIImage(named: $0)!})
//        self.comments = comments
//        self.likesCount = Int.random(in: 1...100)
//        self.viewsCount = Int.random(in: 1...1000)
//    }
//}
//
//class Comment1 {
//    var text : String
//    var author : User
//
//    init(author : User, text : String) {
//        self.author = author
//        self.text = text
//    }
//}
