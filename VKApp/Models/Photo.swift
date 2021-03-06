//
//  Photo.swift
//  VKApp
//
//  Created by Владислав Лихачев on 03.05.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import RealmSwift

class Photo: Object, Decodable, HaveID {
    @objc dynamic var id = 0
    @objc dynamic var albumID = 0
    @objc dynamic var ownerID = 0
    var sizes = List<Size>()
    @objc dynamic var text: String = ""
    @objc dynamic var date: Int = 0
    @objc dynamic var likes: Likes?
    @objc dynamic var reposts: Reposts?
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
        case likes, reposts
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        self.albumID = try container.decode(Int.self, forKey: .albumID)
        self.ownerID = try container.decode(Int.self, forKey: .ownerID)
        self.text = try container.decode(String.self, forKey: .text)
        self.date = try container.decode(Int.self, forKey: .date)
        self.likes = try? container.decodeIfPresent(Likes.self, forKey: .likes) 
        self.reposts = try? container.decodeIfPresent(Reposts.self, forKey: .reposts)
        sizes = try container.decodeIfPresent(List<Size>.self, forKey: .sizes) ?? List()
    }
    
    func getPhotoBigSize() -> UIImage? {
        guard !sizes.isEmpty else {
            return nil
        }
        return UIImage.getImage(from: sizes[sizes.count-1].url)
    }
    
    func getPhotoBigSizeURL() -> String? {
        guard !sizes.isEmpty else {
            return nil
        }
        return sizes[sizes.count-1].url
    }
    
    func getLikesCount() -> Int {
        return likes!.count
    }
    
    func getUserLike() -> Bool {
        return likes!.userLikes > 0 ? true : false
    }
}
// MARK: - Likes
class Likes: Object, Decodable {
    @objc dynamic var userLikes, count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
class Reposts: Object, Decodable {
    @objc dynamic var count: Int
}

// MARK: - Size
class Size: Object, Decodable {
    @objc dynamic var type: String
    @objc dynamic var url: String
    @objc dynamic var width, height: Int
}
