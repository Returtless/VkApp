//
//  AppDelegate.swift
//  weatherApp
//
//  Created by Владислав Лихачев on 24.03.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let coffee = SimpleCoffee()
        
        let milkCoffee = Milk(base: coffee)
        let milkCoffeeWithSugar = Sugar(base: milkCoffee)
        let milkCoffeeWithSugarAndCinnamon = Cinnamon(base: milkCoffeeWithSugar)
        let milkCoffeeWithSugarAndCinnamonAndSyrup = Syrup(base: milkCoffeeWithSugarAndCinnamon)
        print(milkCoffee.cost, milkCoffeeWithSugar.cost, milkCoffeeWithSugarAndCinnamon.cost, milkCoffeeWithSugarAndCinnamonAndSyrup.cost)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

