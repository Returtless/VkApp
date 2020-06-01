//
//  FirebaseUser.swift
//  VKApp
//
//  Created by Владислав Лихачев on 01.06.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseUser {
    var id: Int
    let ref: DatabaseReference?
    
    internal init(id: Int) {
        self.id = id
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: Any],
            let id = value["id"] as? Int
            else {
                return nil
        }
        self.ref = snapshot.ref
        self.id = id
    }
    
    func toAnyObject() -> [String: Any] {
        return [
            "id": id
        ]
    }
}


