//
//  Database.swift
//  VKApp
//
//  Created by Владислав Лихачев on 07.04.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

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
    static func getSortedUsersData() ->[(letter: String, users: [User])] {
        let usersByLetter = Dictionary(grouping: self.getUsersData(), by: { $0.surname.first! })
        return usersByLetter.map({(letter:String($0.key),users: $0.value)}).sorted(by: {$0.letter < $1.letter})
    }
    static func getGroupsData() -> [Group] {
        [
            Group(name: "GeekBrains", avatar: "geekbrains"),
            Group(name: "Youtube", avatar: ""),
            Group(name: "Yandex", avatar: ""),
            Group(name: "Google", avatar: ""),
            Group(name: "Kavabanga", avatar: ""),
            Group(name: "Gogogo", avatar: ""),
            Group(name: "MDK", avatar: ""),
            Group(name: "Dodo pizza", avatar: "dodo")
        ]
    }
    
    static func getNewGroupsData() -> [Group] {
        [
            Group(name: "Dodo pizza Belgorod", avatar: "dodo"),
            Group(name: "Dodo pizza Saint Petersburg", avatar: "dodo"),
            Group(name: "Dodo pizza Moskow", avatar: "dodo"),
            Group(name: "Dodo pizza Samara", avatar: "dodo")
        ]
    }
    
    static func getNewsData() -> [News] {
        [
            News(
                author: User(name: "Евгений",
                             surname: "Елчев",
                             avatar: "eugene"),
                text: "Сами вы злые",
                photos: ["dog1",
                         "dog2",
                         "dog3",
                         "dog4",
                         "dog5"],
                comments: []
            ),
            News(
                author: User(name: "Владислав",
                             surname: "Лихачев",
                             avatar: "vladislav"),
                text: "Какой сериал сейчас смотрите?",
                photos: ["serial1",
                         "serial2",
                         "serial3",
                         "serial4",
                         "serial5",
                         "serial6",
                         "serial7",
                         "serial8",
                         "serial9",
                         "serial10"],
                comments: []
            ),
            News(
                author: User(name: "Станислав",
                             surname: "Белых",
                             avatar: "belih"),
                text: "Мой котейка потянул меня за руку и прижался к ладошке",
                photos: ["cat1",
                         "cat2",
                         "cat3"],
                comments: []
            ),
            News(
                author: User(name: "Виталий",
                             surname: "Кулагин",
                             avatar: "kulagin"),
                text: "Папины дочки топ",
                photos: ["pugovka1",
                         "pugovka2",
                         "pugovka3",
                         "pugovka4",
                         "pugovka5",
                         "pugovka6",
                         "pugovka7",
                         "pugovka8",
                         "pugovka9"],
                comments: []
            ),
            News(
                author: User(name: "Владислав",
                             surname: "Лихачев",
                             avatar: "vladislav"),
                text: "Опубликовал новую фотографию",
                photos: ["vladislav"],
                comments: []
            ),
            News(
                author: User(name: "Евгений",
                             surname: "Елчев",
                             avatar: "eugene"),
                text: "Опубликовал новую фотографию",
                photos: ["eugene"],
                comments: []
            )
        ]
    }
}
