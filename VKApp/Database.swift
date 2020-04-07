//
//  Database.swift
//  VKApp
//
//  Created by Владислав Лихачев on 07.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

class Database{
    static func getUsersData() -> [User] {
        return [
            User(name: "Владислав", surname: "Лихачев", avatar: "vladislav"),
            User(name: "Евгений", surname: "Елчев", avatar: "eugene"),
            User(name: "Александр", surname: "Черных", avatar: "chernih"),
            User(name: "Виталий", surname: "Кулагин", avatar: "kulagin"),
            User(name: "Карим", surname: "Султанов", avatar: "sultanov"),
            User(name: "Сергей", surname: "Логинов", avatar: ""),
            User(name: "Станислав", surname: "Белых", avatar: "belih"),
            User(name: "Артём", surname: "Лукашенко", avatar: ""),
            User(name: "Чеслав", surname: "Молчанов", avatar: ""),
            User(name: "Матвей", surname: "Козлов", avatar: ""),
            User(name: "Шарль", surname: "Ермаков", avatar: ""),
            User(name: "Остап", surname: "Новиков", avatar: ""),
            User(name: "Всеволод", surname: "Сидоров", avatar: ""),
            User(name: "Устин", surname: "Яковенко", avatar: ""),
            User(name: "Эрик", surname: "Рымар", avatar: ""),
            User(name: "Конрад", surname: "Самойлов", avatar: ""),
            User(name: "Георгий", surname: "Поляков", avatar: ""),
            User(name: "Эдуард", surname: "Громов", avatar: ""),
            User(name: "Прохор", surname: "Сасько", avatar: "")
        ]
    }
    
}
