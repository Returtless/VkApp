//
//  AddGroupTableViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class AddGroupTableViewController: UITableViewController {
    var newGroups : [Group] = [
        Group(name: "Dodo pizza Belgorod", avatar: "dodo"),
        Group(name: "Dodo pizza Saint Petersburg", avatar: "dodo"),
        Group(name: "Dodo pizza Moskow", avatar: "dodo"),
        Group(name: "Dodo pizza Samara", avatar: "dodo")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { newGroups.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newGroupCell", for: indexPath) as! AddGroupTableViewCell
        let group = newGroups[indexPath.row]
        cell.groupNameLabel.text = group.name
        cell.groupImageView.image = group.avatar
        return cell
    }
    
}
