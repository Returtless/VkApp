//
//  DataServiceProxy.swift
//  VKApp
//
//  Created by Владислав Лихачев on 14.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class DataServiceProxy: DataServiceInterface {
    func getServerData<T>(method: DataService.Methods, with parameters: Parameters, completion: @escaping (Results<T>?) -> Void) where T : Object, T : Decodable, T : HaveID {
        self.dataService.getServerData(method: method, with: parameters, completion: completion)
        print("Произошел вызов метода getServerData с параметрами: \(parameters)")
    }
    
    func getServerData<T>(method: DataService.Methods, with parameters: Parameters, dataType: T.Type) where T : Object, T : Decodable, T : HaveID {
        self.dataService.getServerData(method: method, with: parameters, dataType: dataType)
        print("Произошел вызов метода getServerData с параметрами: \(parameters)")
    }
    
    func getData<T>(method: DataService.Methods, with parameters: Parameters, dataType: T.Type) where T : Object, T : Decodable, T : HaveID {
        self.getData(method: method, with: parameters, dataType: dataType)
        print("Произошел вызов метода getData с параметрами: \(parameters)")
    }
    
    func postDataToServer<T>(for item: T, method: DataService.Methods) where T : Object, T : Decodable, T : Encodable {
        self.dataService.postDataToServer(for: item, method: method)
        print("Произошла отправка данных \(item) на сервер")
    }
    
    func getUserById(userId: Int, completion: @escaping (User?) -> Void) {
        self.dataService.getUserById(userId: userId, completion: completion)
        print("Произошел вызов метода getUserById для получения пользователя с ИД: \(userId)")
    }
    
    func getNewsfeedComments(completion: @escaping (NewsItems?) -> Void) {
        self.dataService.getNewsfeedComments(completion: completion)
        print("Произошел вызов метода getNewsfeedComments для получения комментариев")
    }
    
    func getNewsfeed(startTime: String = "", startFrom: String = "", completion: @escaping (NewsItems?) -> Void) {
        self.dataService.getNewsfeed(startTime: startTime, startFrom: startFrom, completion: completion)
        print("Произошел вызов метода getNewsfeed для получения ленты новостей")
    }
    
    func getSearchedGroups(searchText: String, completion: @escaping (Results<Group>?) -> Void) {
        self.dataService.getSearchedGroups(searchText: searchText, completion: completion)
        print("Произошел вызов метода getSearchedGroups для поиска группы по подстроке: \(searchText)")
        
    }
    
    func getAllPhotosForUser(userId: Int, completion: @escaping (Results<Photo>?) -> Void) {
        self.dataService.getAllPhotosForUser(userId: userId, completion: completion)
        print("Произошел вызов метода getAllPhotosForUser для получения всех фото пользователя с ИД: \(userId)")
    }
    
    /// Метод для получения всех друзей пользователя
      /// - Parameter completion: замыкание для возврата данных
       func getAllFriends(
          completion: @escaping (_ array : Results<User>?) -> Void){
          let params: Parameters = [
              "fields": "nickname, domain, sex, photo_100"
          ]
          getServerData(
              method: .getFriends,
              with: params,
              completion: completion
          )
      }
      
      /// Метод для обновления информации о друзьях
       func updateAllFriends(){
          let params: Parameters = [
              "fields": "nickname, domain, sex, photo_100"
          ]
          getServerData(
              method: .getFriends,
              with: params,
              dataType : User.self
          )
      }
      
      /// Метод для обновления информации о друзьях c Operation
       func updateAllFriendsWithOperation(){
          let params: Parameters = [
              "fields": "nickname, domain, sex, photo_100"
          ]
          getData(
              method: .getFriends,
              with: params,
              dataType : User.self
          )
      }
      
      /// Метод для получения всех групп пользователя
      /// - Parameter completion: замыкание для возврата данных
       func getAllGroups(
          completion: @escaping (_ array : Results<Group>?) -> Void){
          let params: Parameters = [
              "extended": "1",
              "isMember" : 1
          ]
          getServerData(
              method: .getUserGroups,
              with: params,
              completion: completion
          )
      }
      
      /// Метод для обновления всех групп пользователя
       func updateAllGroups(){
          let params: Parameters = [
              "extended": "1",
              "isMember" : 1
          ]
          getServerData(
              method: .getUserGroups,
              with: params,
              dataType: Group.self
          )
      }
      
      /// Метод для обновления всех групп пользователя c Operation
       func updateAllGroupsWithOperation(){
          let params: Parameters = [
              "extended": "1",
              "isMember" : 1
          ]
          getData(
              method: .getUserGroups,
              with: params,
              dataType: Group.self
          )
      }
    
    let dataService: DataService
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
}
