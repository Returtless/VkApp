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
    
    var groups : Results<Group>? //список отображаемых групп
    var userGroups : Results<Group>?//список групп пользователя
    var groupsToken : NotificationToken?
    var myTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groups = RealmService.getData()?.sorted(byKeyPath: "name")
        pairTableAndRealm()
        let alert = UIAlertController(title: "Важно!", message: "В новой версии появилась возможность вступать и выходить из групп в РЕАЛЬНОМ ВК! Для вступления поиском находим группу и при свайпе влево по ячейке есть кнопка для вступления", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true, completion: nil)
        self.myTimer = Timer(timeInterval: 15.0, target: self, selector: #selector(refresh), userInfo: nil, repeats: true)
        RunLoop.main.add(self.myTimer, forMode: .default)
        tableView.rowHeight = CGFloat(70)
    }
    
    @objc
    func refresh() {
        DataService.getAllGroups(
            completion: {
                [weak self] array in
                self?.groups = array?.sorted(byKeyPath: "name")
                self?.userGroups = self!.groups
            }
        )
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        groups?.count ?? 0
        
    }
    
    
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let joinButton = UIContextualAction(style: .normal, title: "Вступить") {  (contextualAction, view, boolValue) in
            let item = self.groups![indexPath.row]
            //возвращаем наши группы в список
            self.groups = self.userGroups
            tableView.reloadData()
            //добавляем группы в рилм и на сервер ВК
            DataService.postDataToServer(for: item, method: .joinGroup)
            //чистим серчбар
            self.groupsSearchBar.searchTextField.text = nil
            self.groupsSearchBar.endEditing(true)
            boolValue(true)
        }
        let leaveButton = UIContextualAction(style: .normal, title: "Выйти") {  (contextualAction, view, boolValue) in
            let item = self.groups![indexPath.row]
            //возвращаем наши группы в список
            self.groups = self.userGroups
            tableView.reloadData()
            //добавляем группы на сервер ВК and isMember = 0
            DataService.postDataToServer(for: item, method: .leaveGroup)
            //чистим серчбар
            self.groupsSearchBar.searchTextField.text = nil
            self.groupsSearchBar.endEditing(true)
            boolValue(true)
        }
        joinButton.backgroundColor = .green
        leaveButton.backgroundColor = .red
        let swipeActions = UISwipeActionsConfiguration(actions: [leaveButton, joinButton])
        
        return swipeActions
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
