//
//  Coffee.swift
//  VKApp
//
//  Created by Владислав Лихачев on 10.08.2020.
//  Copyright © 2020 Vladislav Likhachev. All rights reserved.
//

import Foundation

protocol Coffee {
    var cost: Int { get }
}

class SimpleCoffee: Coffee {
    var cost: Int {
        return 30
    }
}

protocol CoffeeDecorator: Coffee {
    var additionalCost : Int {get}
    var base: Coffee { get }
    init(base: Coffee)
}

class Milk: CoffeeDecorator {
    let additionalCost = 10
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + additionalCost
    }
}

class Sugar: CoffeeDecorator {
    let additionalCost = 5
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + additionalCost
    }
}

class Cinnamon: CoffeeDecorator {
    let additionalCost = 5
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + additionalCost
    }
}

class Syrup: CoffeeDecorator {
    let additionalCost = 10
    var base: Coffee
    
    required init(base: Coffee) {
        self.base = base
    }
    
    var cost: Int {
        return base.cost + additionalCost
    }
}
