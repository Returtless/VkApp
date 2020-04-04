//
//  FriendTableViewCell.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class FriendTableViewCell: UITableViewCell {

    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var photoView: AvatarView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
