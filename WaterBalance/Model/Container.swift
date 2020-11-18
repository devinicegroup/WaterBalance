//
//  Container.swift
//  WaterBalance
//
//  Created by Sergei Polivanov on 02.11.2020.
//  Copyright © 2020 Sergei Polivanov. All rights reserved.
//

import Foundation

enum ContainerEnum: String {
    case decanter = "Decanter"
    case bottle = "Bottle"
    case bigCup = "Big cup"
    case smallCup = "Small cup"
    case jar = "Jar"
    case glass = "Glass"
    case jarMini = "Jar mini"
    case wineglass = "Wineglass"
    case shot = "Shot"
    case hand = "Hand"
}

struct Container {
    
    var name: String
    var nameForUser: String
    var imageString: String
    var value: Double
    var id: Int
    
    static var containers = [
        Container(name: ContainerEnum.decanter.rawValue, nameForUser: "Графин", imageString: "decanter", value: UserDefaults.standard.double(forKey: ContainerEnum.decanter.rawValue), id: 0),
        Container(name: ContainerEnum.bottle.rawValue, nameForUser: "Бутылка", imageString: "bottle", value: UserDefaults.standard.double(forKey: ContainerEnum.bottle.rawValue), id: 1),
        Container(name: ContainerEnum.bigCup.rawValue, nameForUser: "Большая кружка", imageString: "bigCup", value: UserDefaults.standard.double(forKey: ContainerEnum.bigCup.rawValue), id: 2),
        Container(name: ContainerEnum.smallCup.rawValue, nameForUser: "Чашка", imageString: "smallCup", value: UserDefaults.standard.double(forKey: ContainerEnum.smallCup.rawValue), id: 3),
        Container(name: ContainerEnum.jar.rawValue, nameForUser: "Банка", imageString: "jar", value: UserDefaults.standard.double(forKey: ContainerEnum.jar.rawValue), id: 4),
        Container(name: ContainerEnum.glass.rawValue, nameForUser: "Стакан", imageString: "glass", value: UserDefaults.standard.double(forKey: ContainerEnum.glass.rawValue), id: 5),
        Container(name: ContainerEnum.jarMini.rawValue, nameForUser: "Маленькая банка", imageString: "jarMini", value: UserDefaults.standard.double(forKey: ContainerEnum.jarMini.rawValue), id: 6),
        Container(name: ContainerEnum.wineglass.rawValue, nameForUser: "Бокал", imageString: "wineglass", value: UserDefaults.standard.double(forKey: ContainerEnum.wineglass.rawValue), id: 7),
        Container(name: ContainerEnum.shot.rawValue, nameForUser: "Рюмка", imageString: "shot", value: UserDefaults.standard.double(forKey: ContainerEnum.shot.rawValue), id: 8),
        Container(name: ContainerEnum.hand.rawValue, nameForUser: "Другое", imageString: "hand", value: UserDefaults.standard.double(forKey: ContainerEnum.hand.rawValue), id: 9)
    ]
}
