//
//  FirebaseData.swift
//  VKApp
//
//  Created by Владислав Лихачев on 02.06.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseData {
    var id: Int
    var name: String
    let ref: DatabaseReference?
    
    internal init(id: Int, name: String = "") {
        self.id = id
        self.name = name
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int,
            let name = value["name"] as? String
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.id = id
        self.name = name
    }
    
    func toAnyObject() -> [String: Any] {
        if name == "" {
            return ["id": id]
        } else {
            return [
                "id": id,
                "name": name
            ]
        }
    }
    
   
}
