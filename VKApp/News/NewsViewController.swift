//
//  NewsViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 09.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    var news : NewsItems?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        DataService.getNewsfeed(
            completion: {
                [weak self] array in
                self?.news = array
                self?.tableView.reloadData()
            }
        )
        //news = Database.getNewsData()
    }
}

extension NewsViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let newsItems = news, !newsItems.items.isEmpty else {
            return 0
        }
        return newsItems.items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        guard let newsItems = news, !newsItems.items.isEmpty else {
            return cell
        }
        let currentNews = newsItems.items[indexPath.row]
        // cell.avatarView.imageView.image = currentNews.author.avatar
        let id = currentNews.sourceID
        var authorName = ""
        var authorImage : UIImage?
        if id > 0 {
            if let user = newsItems.profiles.first(where: {$0.id == abs(id)}) {
                authorName = user.getFullName()
                authorImage = UIImage.getImage(from: user.photo100)
            }
        } else {
            if let group = newsItems.groups.first(where: {$0.id == abs(id)}) {
                authorName = group.name
                authorImage = UIImage.getImage(from: group.photo100)
            }
        }
        cell.authorNameLabel.text = authorName
        if let authorImage = authorImage {
            cell.avatarView.imageView.image = authorImage
        }
        let date = NSDate(timeIntervalSince1970: Double(currentNews.date))
        let currentDate = Date()
        let result = currentDate.timeIntervalSince(date as Date)
        cell.photoDelegate = self
        cell.createDateLabel.text = result.toRelativeDateTime()
        cell.messageLabel.text = currentNews.text
        cell.likeCounterControl.isLiked = currentNews.getLikesInfo().1
        cell.likeCounterControl.countOfLikes = currentNews.getLikesInfo().0
        cell.commentsCounter.counterLabel.text = "\(currentNews.comments?.count ?? 0)"
        cell.viewsCounter.text = "\(currentNews.views?.count ?? 0)"
        cell.photos = []
        if !currentNews.attachments.isEmpty {
            for attach in currentNews.attachments {
                if let photos = attach.photo, let bigPhoto = photos.getPhotoBigSize() {
                    cell.photos.append(bigPhoto)
                } else if let link = currentNews.attachments[0].link, let photo = link.photo, let bigPhoto = photo.getPhotoBigSize() {
                    cell.photos.append(bigPhoto)
                } else if currentNews.attachments[0].video != nil{
                    cell.photos = [UIImage(systemName: "arrowtriangle.right.circle")!]
                }
            }
        } else if currentNews.photos != nil{
            if let photo = currentNews.photos!.items[0].getPhotoBigSize() {
                cell.photos = [photo]
                
            }
            
        }
        
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        guard let newsItems = news, !newsItems.items.isEmpty else {
            return
        }
        let currentNews = newsItems.items[indexPath.row]
        cell.likeCounterControl.countOfLikes = currentNews.getLikesInfo().0
        cell.reloadInputViews()
    }
}


extension Date {
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}

extension NewsViewController : CommentCounterDelegate {
    func onButtonTapped(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "News", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "CommentsViewController") as! CommentsViewController
        
        resultViewController.comments = news!.items[0].comments!.list
        navigationController?.pushViewController(resultViewController,
                                                 animated: true)
    }
}

extension NewsViewController : NewsPhotoCollectionViewDelegate {
    func onButtonTapped(_ data : UIImage) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Friends", bundle:nil)
        let resultViewController = storyBoard.instantiateViewController(withIdentifier: "FullPhoto") as! PhotoListViewController
        resultViewController.imageView = PhotoListImageView(image: data)
        resultViewController.newsPhoto = data
        navigationController?.pushViewController(resultViewController,
                                                 animated: true)
    }
}
extension TimeInterval {
    
    func toRelativeDateTime() -> String {
        
        let time = NSInteger(self)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        if hours > 24{
            return "Давно"
        } else if hours > 1 {
            return "\(hours) часов назад"
        } else if minutes > 1 {
            return "\(minutes) минут назад"
        } else {
            return "\(seconds) секунд назад"
        }
    }
}
