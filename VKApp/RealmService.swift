//
//  RealmService.swift
//  VKApp
//
//  Created by Владислав Лихачев on 21.05.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import WebKit
import RealmSwift

class RealmService {
    
    static func getData<T : Object>(for filter : (String, String, String)? = nil, with value : Any? = nil) -> Results<T>?{
        do {
            let realm = try Realm()
            var predicate = NSPredicate(value: true)
            if let filter = filter, let value = value {
                switch filter.2 {
                case "Int":
                    predicate = NSPredicate(format: "\(filter.0) \(filter.1) %@", NSNumber(value: value as! Int))
                default:
                    predicate = NSPredicate(format: "\(filter.0) \(filter.1) %@", value as! String)
                }
            }
            let data = realm.objects(T.self).filter(predicate)
            return data
        } catch {
            print(error)
        }
        return nil
    }
    
    static func saveData<T : Object & HaveID>(_ array: [T], withoutDelete : Bool = false) {
        if (!array.isEmpty) {
            do {
                Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
                let realm = try Realm()
                print(realm.configuration.fileURL)
                realm.beginWrite()
                
                if T.self == Photo.self{//для обновления фотографий нужно удалить только фото по определенному юзеру и sizes для каждой из них
                    let objects = realm.objects(T.self).filter(NSPredicate(format: "ownerID == %@", NSNumber(value: (array[0] as! Photo).ownerID)))
                    if !objects.isEmpty && !withoutDelete{
                        for photo in objects{
                            realm.delete((photo as! Photo).sizes)
                        }
                        realm.delete(objects)
                        for object in objects {
                            print("Удален объект типа \(T.self) с ИД = \(object.id)")
                        }
                    }
                } else {
                    //для остальных - нужно удалить элементы, которых больше нет в БД
                    let objects = realm.objects(T.self).filter { x in !array.contains(where : { $0.id == x.id }) }
                    if !objects.isEmpty {
                        for object in objects {
                            print("Удален объект типа \(T.self) с ИД = \(object.id)")
                        }
                        realm.delete(objects)
                    }
                }
                
                realm.add(array, update: .modified)
                try realm.commitWrite()
            } catch {
                print(error)
            }
        }
    }
}
