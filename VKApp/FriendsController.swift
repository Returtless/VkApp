//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
    var users : [User] = [
        User(name: "Владислав", surname: "Лихачев", avatar: "vladislav"),
        User(name: "Евгений", surname: "Ёлчев", avatar: "eugene"),
        User(name: "Александр", surname: "Черных", avatar: "chernih"),
        User(name: "Виталий", surname: "Кулагин", avatar: "kulagin"),
        User(name: "Карим", surname: "Султанов", avatar: "sultanov"),
        User(name: "Станислав", surname: "Белых", avatar: "belih")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        let user = users[indexPath.row]
        cell.userLabel.text = "\(user.name) \(user.surname)"
        cell.userLabel.font = .systemFont(ofSize: CGFloat(16))
        cell.photoView.imageView.image = user.avatar
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue" {
            let photoAlbumVC = segue.destination as! PhotoAlbumController
            if let index = tableView.indexPathForSelectedRow {
                let user = users[index.row]
                photoAlbumVC.photos = user.photos
                photoAlbumVC.title = "\(user.name) \(user.surname)"
            }
        }
    }
    
}


