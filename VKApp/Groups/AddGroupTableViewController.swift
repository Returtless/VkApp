//
//  AddGroupTableViewController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class AddGroupTableViewController: UITableViewController {
    var newGroups : [Group] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //newGroups = Database.getNewGroupsData()
        tableView.rowHeight = CGFloat(70)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { newGroups.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newGroupCell", for: indexPath) as! AddGroupTableViewCell
        let group = newGroups[indexPath.row]
        cell.groupNameLabel.text = group.name
        //cell.groupImageView.imageView.image = group.avatar
        return cell
    }
    
}
