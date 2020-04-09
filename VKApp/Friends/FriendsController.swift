//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsController: UIViewController {
    
    var usersBySections: [(letter: String, users: [User])] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var friendSearchBar: FriendsSearchBar!
    
    var sorterControl: SorterBarControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = CGFloat(70)
        sorterControl = SorterBarControl()
        sorterControl.addTarget(self, action: #selector(sorterBarWasChanged), for: .valueChanged)
        view.addSubview(sorterControl)
        usersBySections = Database.getSortedUsersData()
        sorterControl.letters = usersBySections.map({$0.letter})
        sorterControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sorterControl.widthAnchor.constraint(equalToConstant: CGFloat(20)),      sorterControl.heightAnchor.constraint(equalToConstant: CGFloat(30*sorterControl.letters.count)), sorterControl.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            sorterControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoAlbumSegue" {
            let photoAlbumVC = segue.destination as! PhotoAlbumController
            if let index = tableView.indexPathForSelectedRow {
                let user = usersBySections[index.section].users[index.row]
                photoAlbumVC.photos = user.photos
                photoAlbumVC.title = "\(user.name) \(user.surname)"
            }
        }
    }
    
    @objc func sorterBarWasChanged(_ sender: SorterBarControl) {
        let indexPath = IndexPath(row: 0, section: usersBySections.firstIndex(where: {$0.letter == sender.choosedLetter}) ?? 0)
        self.tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        
    }
}

extension FriendsController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int { self.usersBySections.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {  self.usersBySections[section].users.count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(self.usersBySections[section].letter)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! FriendTableViewCell
        let user = usersBySections[indexPath.section].users[indexPath.row]
        cell.userLabel.text = "\(user.name) \(user.surname)"
        cell.userLabel.font = .systemFont(ofSize: CGFloat(16))
        cell.photoView.imageView.image = user.avatar
        
        return cell
    }
}
extension FriendsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        usersBySections = Database.getSortedUsersData()
        if (!searchText.isEmpty){
            for i in 0..<usersBySections.count {
                usersBySections[i].users = usersBySections[i].users.filter({$0.surname.range(of:  searchText, options: .caseInsensitive) != nil || $0.name.range(of:  searchText, options: .caseInsensitive) != nil })
            }
            usersBySections.removeAll(where: {$0.users.isEmpty})
        }
        sorterControl.letters = usersBySections.map({$0.letter})
        tableView.reloadData()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        friendSearchBar.endEditing(true)
    }
}

