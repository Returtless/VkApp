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

class DataService {
    // MARK: - Get static methods
    static func getAllFriends(
        completion: @escaping (_ array : Results<User>?) -> Void){
        let params: Parameters = [
            "fields": "nickname, domain, sex, photo_100"
        ]
        DataService.getServerData(
            method: .getFriends,
            with: params, typeName: User.self,
            completion: completion
        )
        
    }
    
    static func getAllGroups(
        completion: @escaping (_ array : Results<Group>?) -> Void){
        let params: Parameters = [
            "extended": "1",
            "isMember" : 1
        ]
        DataService.getServerData(
            method: .getUserGroups,
            with: params, typeName: Group.self,
            completion: completion
        )
    }
    
    static func getAllPhotosForUser(userId : Int,
                                    completion: @escaping (_ array : Results<Photo>?) -> Void) {
        let params: Parameters = [
            "extended": "1",
            "owner_id" : userId
        ]
        DataService.getServerData(
            method: .getAllPhotos,
            with: params, typeName: Photo.self,
            completion: completion
        )
    }
    
    static func getSearchedGroups(searchText : String,
                                  completion: @escaping (_ array : Results<Group>?) -> Void) {
        let params: Parameters = [
            "q": searchText,
            "count" : 100,
            Constants.useOnlyServerData.rawValue : false
        ]
        DataService.getServerData(
            method: .getSearchGroups,
            with: params, typeName: Group.self,
            completion: completion
        )
    }

    static func getNewsfeed(completion: @escaping (_ array : NewsItems?) -> Void) {
        let params: Parameters = [
            "count" : 10,
            "filters" : "post",
            Constants.useOnlyServerData.rawValue : false
        ]
        AF.request("https://api.vk.com/method/" + Methods.getNews.rawValue,
                   parameters: getFullParameters(params)).responseJSON{ response in
                    do {
                        print("News получены с сервера ВК")
                        
                        guard let data = response.data else { return }
                        let res = try JSONDecoder().decode(ResponseNews.self, from: data)
                        completion(res.response)
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
    }
    
    static func getDataFromRealm<T : Object>(params : Parameters = Parameters()) -> Results<T>?{
        let filteredFields : [String : (String, String, String)] = [
            "owner_id" : ("ownerID", "==", "Int"),
            "q" : ("name", "CONTAINS[c]", "String"),
            "isMember" : ("isMember", "==", "Int"),
            "lastName" : ("lastName", "CONTAINS[c]", "String")
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
            return data
        } catch {
            print(error)
        }
        return nil
    }
    
    // MARK: - Post static methods
    static func postDataToServer<T: Object & Codable>(for item: T, method : Methods){
        switch method {
        case .joinGroup, .leaveGroup:
            let params: Parameters = ["group_id" : (item as! Group).id]
            AF.request("https://api.vk.com/method/" + method.rawValue, method: .post,
                       parameters: getFullParameters(params)).responseJSON(completionHandler:  {
                        response in
                        print(response.result)
                       })
            let realm = try! Realm()
            do {
                realm.beginWrite()
                (item as! Group).isMember = method == .joinGroup ? 1 : 0
                realm.add(item)
                try realm.commitWrite()
            } catch let e {
                print(e)
            }
        default:
            return
        }
    }
    // MARK: - private methods
    private static func getServerData<T : Decodable & Object>(method : Methods,
                                                                with parameters: Parameters,
                                                                typeName : T.Type,
                                                                completion: @escaping (_ array : Results<T>?) -> Void){
          let dataFromRealm : Results<T>? = getDataFromRealm(params: parameters)
          let useOnlyServerData : Bool = parameters[Constants.useOnlyServerData.rawValue] as? Bool ?? false
          //если данные есть в БД, то берем их оттуда, иначе делаем запрос к серверу
          //ИЛИ если использован параметр useOnlyServerData
          if dataFromRealm == nil || dataFromRealm!.isEmpty || useOnlyServerData  {
              AF.request("https://api.vk.com/method/" + method.rawValue,
                         parameters: getFullParameters(parameters)).responseJSON{ response in
                          
                          print("\(typeName)s получены с сервера ВК")
                          
                          guard let data = response.data else { return }
                          let array: [T]? = decodeRequestData(method: method, data: data)
                          if let array = array {
                              //сохрняем данные в БД
                              saveDataToRealm(array, withoutDelete : !useOnlyServerData)
                              //получаем сохраненные данные из БД, чтобы получился Results<T>
                              completion(getDataFromRealm(params: parameters))
                          }
              }
          } else {
              print("\(typeName)s получены из Realm")
              completion(dataFromRealm)
          }
          
      }
      
    
    private static func decodeRequestData<T : Object & Decodable>(method : Methods,
                                                                  data: Data) -> [T]? {
        var array = Array<Any>()
        do {
            let res : Any?
            switch method {
            case .getFriends :
                res = try JSONDecoder().decode(Response<User>.self, from: data)
            case .getUserGroups, .getSearchGroups, .getGroupById :
                res = try JSONDecoder().decode(Response<Group>.self, from: data)
            case .getAllPhotos :
                res = try JSONDecoder().decode(Response<Photo>.self, from: data)
            default :
                return nil
            }
            array = (res! as! Response<T>).response.items
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
        return array as? [T]
    }
    
    private static func saveDataToRealm<T : Object>(_ array: [T], withoutDelete : Bool = false) {
        do {
            Realm.Configuration.defaultConfiguration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm()
            //print(realm.configuration.fileURL)
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
    
    
    
    private static func getFullParameters(_ params : Parameters) -> Parameters {
        var parameters = params
        parameters.removeValue(forKey: Constants.useOnlyServerData.rawValue)
        parameters["access_token"] = Session.instance.token
        parameters["v"] = "5.103"
        return parameters
    }
    
    
    private enum RequestTypes: String {
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
        case joinGroup = "groups.join"
        case leaveGroup = "groups.leave"
        case getUsers = "users.get"
    }
    
}

enum Constants : String {
    case useOnlyServerData
}
