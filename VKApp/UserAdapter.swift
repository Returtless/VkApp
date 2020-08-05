//
//  UserAdapter.swift
//  VKApp
//
//  Created by Владислав Лихачев on 05.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import RealmSwift

class UserAdapter {
    
    private var usersToken: NotificationToken?
    
    func getUsers(completion: @escaping (_ array : [SimpleUser]) -> Void) {
        let realmUsers : Results<User>? = RealmService.getData()?.sorted(byKeyPath: "lastName")
        
        usersToken = realmUsers?.observe { (changes: RealmCollectionChange) in
            switch changes {
            case .update(_,_,_,_):
                var simpleUsers: [SimpleUser] = []
                for realmUser in realmUsers! {
                    simpleUsers.append(self.user(from: realmUser ))
                }
                completion(simpleUsers)
                
            case .error(let error):
                fatalError("\(error)")
            case .initial(_):
                break
            }
        }
        
    }
    
    private func user(from realmUser: User) -> SimpleUser {
        return SimpleUser(firstName: realmUser.firstName, id: realmUser.id, lastName: realmUser.lastName, nickname: realmUser.nickname, online: realmUser.online, photo100: realmUser.photo100, sex: realmUser.sex)
    }
}
