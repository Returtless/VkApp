//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsController: UIViewController {
    var sorterView = SorterBarControl()
    
    @IBOutlet weak var tableView: UITableView!
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
        tableView.addSubview(sorterView)
        sorterView.translatesAutoresizingMaskIntoConstraints = false
        sorterView.frame = CGRect(x: 0, y: 0, width: 20, height: 100)

        NSLayoutConstraint.activate([
            sorterView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            sorterView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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

extension FriendsController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { users.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        let user = users[indexPath.row]
        cell.userLabel.text = "\(user.name) \(user.surname)"
        cell.userLabel.font = .systemFont(ofSize: CGFloat(16))
        cell.photoView.imageView.image = user.avatar
        return cell
    }
}

