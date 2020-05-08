//
//  VKServerFactory.swift
//  VKApp
//
//  Created by Владислав Лихачев on 02.05.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import RealmSwift

class VKServerFactory {
    
    static func getServerData<T : Object>(method : Methods,
                                          with parameters: Parameters,
                                          typeName : T.Type,
                                          completion: @escaping (_ array : Array<Any>?) -> Void){
        let dataFromRealm : [T] = getDataFromRealm(params: parameters)
        let useOnlyServerData : Bool = parameters[Constants.useOnlyServerData.rawValue] as? Bool ?? false
        //если данные есть в БД, то берем их оттуда, иначе делаем запрос к серверу
        //ИЛИ если использован параметр useOnlyServerData
        if dataFromRealm.isEmpty || useOnlyServerData  {
            var array = Array<Any>()
            AF.request("https://api.vk.com/method/\(method.rawValue)", parameters: getFullParameters(parameters)).responseJSON{ response in
                
                guard let data = response.data else { return }
                
                do {
                    switch method {
                    case .getFriends :
                        let res = try JSONDecoder().decode(ResponseUsers.self, from: data)
                        array = res.response.items
                    case .getUserGroups, .getSearchGroups, .getGroupById :
                        let res = try JSONDecoder().decode(ResponseGroups.self, from: data)
                        array = res.response.items
                    case .getAllPhotos :
                        let res = try JSONDecoder().decode(ResponsePhotos.self, from: data)
                        array = res.response.items
                    default :
                        return
                    }
                    saveDataToRealm(array as! [T], withoutDelete : !useOnlyServerData)
                    completion(array as! [T])
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:",  context.codingPath)
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                } catch {
                    print("error: ", error)
                }
            }
        } else {
            completion(dataFromRealm)
        }
        
    }
    
    static func saveDataToRealm<T : Object>(_ array: [T], withoutDelete : Bool = false) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            print(realm.configuration.fileURL)
            realm.beginWrite()
            let objects = realm.objects(T.self)
            if !objects.isEmpty && !withoutDelete{
                realm.delete(objects)
            }
            realm.add(array, update: .modified)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    static func getDataFromRealm<T : Object>(params : Parameters = Parameters()) -> [T]{
        let filteredFields : [String : (String,String, String)] = [
            "owner_id" : ("ownerID", "==", "Int"),
            "q" : ("name", "CONTAINS[c]", "String"),
            "isMember" : ("isMember", "==", "Int")
        ]
        do {
            let realm = try Realm()
            var predicate = NSPredicate(value: true)
            let filteredParams = params.filter({
                filteredFields[$0.key] != nil
            })
            //Составление предиката для выборки данных из БД
            if let filterParam = filteredParams.first, let filterTuple = filteredFields[filterParam.key] {
                switch filterTuple.2 {
                case "Int":
                    predicate = NSPredicate(format: "\(filterTuple.0) \(filterTuple.1) %@", NSNumber(value: filterParam.value as! Int))
                default:
                    predicate = NSPredicate(format: "\(filterTuple.0) \(filterTuple.1) %@", filterParam.value as! String)
                }
            }
            let data = realm.objects(T.self).filter(predicate)
            return Array(data.map({$0 as T}))
        } catch {
            print(error)
        }
        return Array()
    }
    
    static func getFullParameters(_ params : Parameters) -> Parameters {
        var parameters = params
        parameters.removeValue(forKey: Constants.useOnlyServerData.rawValue)
        parameters["access_token"] = Session.instance.token
        parameters["v"] = "5.103"
        return parameters
    }
    
    
    enum RequestTypes: String {
        case auth
        case method
    }
    
    enum Methods: String {
        case getFriends = "friends.get"
        case authorize
        case getAllPhotos = "photos.getAll"
        case getUserGroups = "groups.get"
        case getSearchGroups = "groups.search"
        case getGroupById = "groups.getById"
        case getNews = "newsfeed.get"
    }
    
}

enum Constants : String {
    case useOnlyServerData
}
