//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsController: UIViewController {
    
    @IBAction func sorterBarWasChanged(_ sender: SorterBarControl) {
        let indexPath = IndexPath(row: 0, section: usersBySections.firstIndex(where: {String($0.key) == sender.choosedLetter}) ?? 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
    
    @IBOutlet weak var sorterControl: SorterBarControl!
    @IBOutlet weak var tableView: UITableView!
    var users : [User] = []
    var sectionLetters = [String]()
    var usersBySections: [(key: String.Element, value: [User])] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        users = setUsersArray()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CGFloat(70)
        
        let usersByLetter = Dictionary(grouping: users, by: { $0.surname.first! })
        sectionLetters = Array(usersByLetter.keys.map({String($0)})).sorted(by: <)
        sorterControl.letters = sectionLetters
        usersBySections = Array(usersByLetter).sorted(by: {$0.key < $1.key})
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue" {
            let photoAlbumVC = segue.destination as! PhotoAlbumController
            if let index = tableView.indexPathForSelectedRow {
                let user = usersBySections[index.section].value[index.row]
                photoAlbumVC.photos = user.photos
                photoAlbumVC.title = "\(user.name) \(user.surname)"
            }
        }
    }
    
    private func setUsersArray() -> [User] {
        return [
            User(name: "Владислав", surname: "Лихачев", avatar: "vladislav"),
            User(name: "Евгений", surname: "Елчев", avatar: "eugene"),
            User(name: "Александр", surname: "Черных", avatar: "chernih"),
            User(name: "Виталий", surname: "Кулагин", avatar: "kulagin"),
            User(name: "Карим", surname: "Султанов", avatar: "sultanov"),
            User(name: "Сергей", surname: "Логинов", avatar: ""),
            User(name: "Станислав", surname: "Белых", avatar: "belih"),
            User(name: "Артём", surname: "Лукашенко", avatar: ""),
            User(name: "Чеслав", surname: "Молчанов", avatar: ""),
            User(name: "Матвей", surname: "Козлов", avatar: ""),
            User(name: "Шарль", surname: "Ермаков", avatar: ""),
            User(name: "Остап", surname: "Новиков", avatar: ""),
            User(name: "Всеволод", surname: "Сидоров", avatar: ""),
            User(name: "Устин", surname: "Яковенко", avatar: ""),
            User(name: "Эрик", surname: "Рымар", avatar: ""),
            User(name: "Конрад", surname: "Самойлов", avatar: ""),
            User(name: "Георгий", surname: "Поляков", avatar: ""),
            User(name: "Эдуард", surname: "Громов", avatar: ""),
            User(name: "Прохор", surname: "Сасько", avatar: "")
        ]
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

