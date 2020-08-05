//
//  UserViewModelFactory.swift
//  VKApp
//
//  Created by Владислав Лихачев on 05.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NewsViewModelFactory {
    private var photoService: PhotoService?
    
    func constructViewModels(from news: [News], users: [User], groups: [Group]) -> [NewsViewModel] {
        photoService = PhotoService()
        var models: [NewsViewModel] = []
        for i in 0..<news.count {
            models.append(viewModel(from: news[i], users: users, groups: groups))
        }
        return models
    }
    
    private func viewModel(from currentNews: News, users: [User], groups: [Group]) -> NewsViewModel {
        
        let id = currentNews.sourceID
        var author : (name: String, photo: UIImage?) = ("", nil)
        if id > 0 {
            if let user = users.first(where: {$0.id == abs(id)}), let photo = photoService?.getPhoto(atIndexPath: nil, byUrl: user.photo100) {
                author.name = user.getFullName()
                author.photo = photo
            }
        } else {
            if let group = groups.first(where: {$0.id == abs(id)}), let photo = photoService?.getPhoto(atIndexPath: nil, byUrl: group.photo100) {
                author.name = group.name
                author.photo = photo
            }
        }
        
        let authorNameText = author.name
        var authorImage : UIImage = UIImage()
        if let img = author.photo {
            authorImage = img
        }
        let createDateText = formatTimeAgo(date: currentNews.date)
        let messageLabelText = currentNews.text
        let likesCount = currentNews.getLikesInfo().0
        let isLiked = currentNews.getLikesInfo().1
        let commentsCount = currentNews.comments?.count ?? 0
        let viewsCount = currentNews.views?.count ?? 0
        
        let photos  = configurePhotoList(for: currentNews)
        
        return NewsViewModel(authorNameText: authorNameText, createDateText: createDateText, authorImage: authorImage, messageText: messageLabelText, likesCount: likesCount, isLiked: isLiked, commentsCount: commentsCount, viewsCount: viewsCount, photos: photos)
    }
    
    private func configurePhotoList(for currentNews: News) -> [UIImage]{
        var cellPhotos = [UIImage]()
        if !currentNews.attachments.isEmpty {
            for attach in currentNews.attachments {
                var photo : Photo = Photo()
                if let photos = attach.photo {
                    photo = photos
                } else if let link = attach.link, let photos = link.photo{
                    photo = photos
                }
                
                if let url = photo.getPhotoBigSizeURL(), let bigPhoto = photoService?.getPhoto(atIndexPath: nil, byUrl: url) {
                    cellPhotos.append(bigPhoto)
                }
            }
        } else if currentNews.photos != nil{
            if let url = currentNews.photos!.items[0].getPhotoBigSizeURL(), let bigPhoto = photoService?.getPhoto(atIndexPath: nil, byUrl: url) {
                cellPhotos = [bigPhoto]
            }
        }
        if (cellPhotos.isEmpty){
            cellPhotos = [UIImage(systemName: "arrowtriangle.right.circle")!]
        }
        return cellPhotos
    }
    private func formatTimeAgo(date: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(date))
        let result = Date().timeIntervalSince(date as Date)
        return result.toRelativeDateTime()
    }
}


struct NewsViewModel {
    let authorNameText: String
    let createDateText: String
    let authorImage: UIImage?
    let messageText: String
    let likesCount: Int
    let isLiked: Bool
    let commentsCount: Int
    let viewsCount: Int
    let photos: [UIImage]
}
