//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class GroupsController: UITableViewController {
    
    var groups : [Group] = [Group(name: "GeekBrains", avatar: "geekbrains"), Group(name: "Dodo pizza", avatar: "dodo")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { groups.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        cell.avatarImageView.image = group.avatar
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
    @IBAction func addNewGroup(segue: UIStoryboardSegue) {
        if segue.identifier == "addNewGroup" {
            guard let addGroupController = segue.source as? AddGroupTableViewController else { return }
            if let indexPath = addGroupController.tableView.indexPathForSelectedRow {
                let group = addGroupController.newGroups[indexPath.row]
                if !groups.contains(group) {
                    groups.append(group)
                    tableView.reloadData()
                }
            }
        }
    }
    
    
}
