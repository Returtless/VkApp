//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class GroupsController: UITableViewController {
    @IBOutlet weak var groupsSearchBar: GroupsSearchBar!
    
    var groups : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groups = Database.getGroupsData()
        tableView.rowHeight = CGFloat(70)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { groups.count }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupTableViewCell
        
        let group = groups[indexPath.row]
        cell.groupNameLabel.text = group.name
        cell.avatarImageView.imageView.image = group.avatar
        
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

extension GroupsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        groups = Database.getGroupsData()
        if (!searchText.isEmpty){
            groups = groups.filter({$0.name.range(of:  searchText, options: .caseInsensitive) != nil})
        }
        tableView.reloadData()
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        groupsSearchBar.endEditing(true)
    }
}
