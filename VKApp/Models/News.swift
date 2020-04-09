//
//  News.swift
//  VKApp
//
//  Created by Владислав Лихачев on 09.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class News{
    
    var author : User
    var createDate : Date
    var text : String
    var photos : [UIImage]
    var comments : [Comment]
    var likesCount : Int
    var viewsCount : Int
    
    init(author : User, text : String, photos : [String], comments : [Comment]) {
        self.author = author
        self.createDate = Date.init()
        self.text = text
        self.photos = photos.map({UIImage(systemName: $0)!})
        self.comments = comments
        self.likesCount = Int.random(in: 1...100)
        self.viewsCount = Int.random(in: 1...1000)
    }
}

class Comment {
    var text : String
    var author : User
    
    init(author : User, text : String) {
        self.author = author
        self.text = text
    }
}
