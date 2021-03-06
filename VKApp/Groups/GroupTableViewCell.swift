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

    @IBOutlet private weak var groupNameLabel: UILabel!
    @IBOutlet private weak var avatarImageView: AvatarView!
   
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func configure(with group: Group, image: UIImage?) {
        groupNameLabel.text = group.name
        if let image = image {
            avatarImageView.imageView.image = image
        }
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.8,
            options:.curveEaseInOut,
            animations: { [weak self] in
                self!.frame.origin.x+=70
        })
    }
}
