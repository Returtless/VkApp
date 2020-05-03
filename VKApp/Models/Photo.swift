//
//  Photo.swift
//  VKApp
//
//  Created by Владислав Лихачев on 03.05.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

// MARK: - Group
class ResponsePhotos: Decodable {
    var response: PhotoItems
}

// MARK: - Response
class PhotoItems: Decodable {
    var count: Int
    var items: [Photo]
}

// MARK: - Item
class Photo: Decodable {
    var id, albumID, ownerID: Int
    var sizes: [Size]
    var text: String
    var date: Int
    var likes: Likes
    var reposts: Reposts

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
        case likes, reposts
    }
    
    func getPhotoBigSize() -> UIImage? {
        guard let photo = self.sizes.first(where: {$0.type == "z"}) else {
            return nil
        }
        return UIImage.getImage(from: photo.url)
    }
    
    func getLikesCount() -> Int {
        return likes.count
    }
    
    func getUserLike() -> Bool {
        return likes.userLikes > 0 ? true : false
    }
}
// MARK: - Likes
class Likes: Codable {
    var userLikes, count: Int

    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
class Reposts: Codable {
    var count: Int
}

// MARK: - Size
class Size: Decodable {
    var type: String
    var url: String
    var width, height: Int
}
