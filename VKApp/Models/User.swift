//
//  User.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class User {
    var name : String
    var surname : String
    var avatar : UIImage?
    var photos : [Photo] = []
    
    init(name : String, surname : String, avatar : String) {
        self.name = name
        self.surname = surname
        let img = !avatar.isEmpty ? UIImage(named: avatar) : UIImage.init(systemName: "nosign")
        self.avatar = img
        if let unwrappedImage = img {
            self.photos = [Photo(image: unwrappedImage, countOfLikes: Int.random(in: 0...100)),Photo(image: UIImage(named: "vladislav")!, countOfLikes: Int.random(in: 0...100)),Photo(image: UIImage(named: "eugene")!, countOfLikes: Int.random(in: 0...100))]//Array(repeating: Photo(image: unwrappedImage, countOfLikes: Int.random(in: 0...100), liked: Bool.random()), count: 10)
        }
    }
    func getFullName() -> String {
        "\(self.name) \(self.surname)"
    }
}

struct Photo {
    var image = UIImage()
    var countOfLikes = 0
    var liked = false
}
