//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import RealmSwift

class GroupsController: UITableViewController {
    
    @IBOutlet weak var groupsSearchBar: GroupsSearchBar!
    
    var groups : Results<Group>?//список отображаемых групп
    var userGroups : Results<Group>?//список групп пользователя
    var groupsToken : NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DataService.getAllGroups(
            completion: {
                [weak self] array in
                self?.groups = array?.sorted(byKeyPath: "name")
                self?.userGroups = self!.groups
                self?.pairTableAndRealm()
                self?.tableView.reloadData()
            }
        )
        
        tableView.rowHeight = CGFloat(70)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { groups?.count ?? 0 }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        
        let group = groups![indexPath.row]
        cell.groupNameLabel.text = group.name
        if let image = UIImage.getImage(from: group.photo100) {
            cell.avatarImageView.imageView.image = image
        }
        return cell
    }
    
    func pairTableAndRealm() {
        userGroups = groups
        groupsToken = groups?.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
}

extension GroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        groups = userGroups
        if (!searchText.isEmpty){
            DataService.getSearchedGroups(
                searchText: searchText,
                completion: {
                    [weak self] array in
                    self?.groups = array
                    self?.tableView.reloadData()
                }
            )
        } else {
            groups = userGroups
            tableView.reloadData()
        }
        
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        groupsSearchBar.endEditing(true)
    }
}
