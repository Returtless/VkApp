//
//  GroupsController.swift
//  VKApp
//
//  Created by Владислав Лихачев on 29.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.tableView.backgroundColor = #colorLiteral(red: 0.3215686275, green: 0.462745098, blue: 0.6431372549, alpha: 1)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       if segue.identifier == "photoAlbumSegue" {
          return
       }
    }

}
