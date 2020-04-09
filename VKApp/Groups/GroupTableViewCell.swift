//
//  GroupTableViewCell.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var avatarImageView: AvatarView!
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
