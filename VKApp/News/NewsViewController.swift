//
//  NewsViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 09.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    var news = [News]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        news = Database.getNewsData()

        // Do any additional setup after loading the view.
    }
}

extension NewsViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  self.news.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsTableViewCell
        let currentNews = news[indexPath.row]
        cell.avatarView.imageView.image = currentNews.author.avatar
        cell.authorNameLabel.text = currentNews.author.getFullName()
        
        let formate = Date.getFormattedDate(date: currentNews.createDate, format: "dd.MM.yyyy")
        cell.createDateLabel.text = formate
        
        
        cell.messageLabel.text = currentNews.text
        cell.likeCounterControl.isLiked = true
        cell.likeCounterControl.countOfLikes = 10
        
        cell.viewsCounter.text = "👁 \(UInt.random(in: 1...100))"
        
        cell.photos = currentNews.photos
        return cell
    }
}


extension Date {
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}
