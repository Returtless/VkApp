//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsController: UIViewController {
    
    @IBOutlet weak var sorterControl: SorterBarControl!
    @IBOutlet weak var tableView: UITableView!
    var users : [User] = [
        User(name: "Владислав", surname: "Лихачев", avatar: "vladislav"),
        User(name: "Евгений", surname: "Елчев", avatar: "eugene"),
        User(name: "Александр", surname: "Черных", avatar: "chernih"),
        User(name: "Виталий", surname: "Кулагин", avatar: "kulagin"),
        User(name: "Карим", surname: "Султанов", avatar: "sultanov"),
        User(name: "Сергей", surname: "Логинов", avatar: "vladislav"),
        User(name: "Станислав", surname: "Белых", avatar: "belih")
    ]
    var sectionLetters = [String]()
    var usersBySections: [(key: String.Element, value: [User])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        let usersByLetter = Dictionary(grouping: users, by: { $0.surname.first! })
        sectionLetters = Array(usersByLetter.keys.map({String($0)})).sorted(by: <)
        sorterControl.letters = sectionLetters
        usersBySections = Array(usersByLetter).sorted(by: {$0.key < $1.key})
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
    func numberOfSections(in tableView: UITableView) -> Int { sectionLetters.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  self.usersBySections[section].value.count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(self.usersBySections[section].key)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        let user = usersBySections[indexPath.section].value[indexPath.row]
        cell.userLabel.text = "\(user.name) \(user.surname)"
        cell.userLabel.font = .systemFont(ofSize: CGFloat(16))
        cell.photoView.imageView.image = user.avatar
        return cell
    }
}

