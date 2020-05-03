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

class VKServerFactory {
    
    static func getServerData(method : Methods,
                              with parameters: Parameters,
                              completion: @escaping (_ array : Array<Any>?) -> Void
    ) {
        
        
        var array = Array<Any>()
        AF.request("https://api.vk.com/method/\(method.rawValue)", parameters: getFullParameters(parameters)).responseJSON{ response in
            
            guard let data = response.data else { return }
            
            do {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions())
                    print(json)
                } catch {
                    print(error)
                }
                switch method {
                case .getFriends :
                    let res = try JSONDecoder().decode(ResponseUsers.self, from: data)
                    array = res.response.items
                case .getUserGroups, .getSearchGroups :
                    let res = try JSONDecoder().decode(ResponseGroups.self, from: data)
                    array = res.response.items
                case .getAllPhotos :
                    let res = try JSONDecoder().decode(ResponsePhotos.self, from: data)
                    array = res.response.items
                default :
                    return
                }
                completion(array)
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
        //return array
    }
    
    static func getFullParameters(_ params : Parameters) -> Parameters {
        var parameters = params
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
    }
}
