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
    private let color = UIColor(hex: "#6689B3ff")
    
    func configure(with text: String) {
        self.tintColor = color
        textLabel!.backgroundColor = color
        textLabel!.text = text
    }
    
}
