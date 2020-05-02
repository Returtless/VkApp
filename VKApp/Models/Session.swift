//
//  Session.swift
//  VKApp
//
//  Created by Владислав Лихачев on 02.05.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//
import UIKit
import WebKit
import Alamofire

class Session {
    var token : String = ""
    var iserId : Int = 0
    var friends = [Friend]()
    static let instance = Session()
    
    func getFriendsList(completion: @escaping (_ success: Any) -> Void){
        let paramters: Parameters = [
            "fields": "nickname, domain, sex",
            "access_token":  token,
            "v": "5.103"
        ]
        AF.request("https://api.vk.com/method/friends.get", parameters: paramters).responseJSON{ response in
          
            guard let data = response.data else { return }
            
            do {
                let response = try JSONDecoder().decode(ResponseFriends.self, from: data)
                self.friends = response.response.items
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
        completion(true)
    }
}
