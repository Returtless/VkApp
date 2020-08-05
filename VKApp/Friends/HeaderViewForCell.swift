//
//  HeaderViewForCell.swift
//  VKApp
//
//  Created by Владислав Лихачев on 15.07.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

class HeaderViewForCell: UITableViewHeaderFooterView {
    static let identifier = "headerViewCell"
    
    func configure(with text: String) {
        self.tintColor = UIColor.vkColor
        textLabel!.backgroundColor = UIColor.vkColor
        textLabel!.text = text
    }
    
}
