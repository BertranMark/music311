//
//  UIViewController + Storyboard.swift
//  music311
//
//  Created by Bertran on 05.05.2020.
//  Copyright © 2020 Bertran. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    class func loadFromStoryboard<T: UIViewController>() -> T {
        // Универсальное решение по созданию и инициализации контроллера, настроенного в сториборде
        // функция класса UIViewController
        // работает с объектами любого типа Т, который наследуется от UIViewController
        let name = String(describing: T.self)
        // Имя типа переводим в строку, чтобы найти одноименный сториборд
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if let viewController = storyboard.instantiateInitialViewController()
            // создаем начальный контроллер и инициализируем его из данных сториборда
            as? T {
            // пытаемся привестии его к типу Т. Функция сработает только на нужном контроллере, а именно SerachViewController в данном проекте, так как именно для его класса описан одноименный и начальный контроллер в сториборде. У меня остался вопрос, зачем это делать, если в сториборде контроллер связан с классом
            return viewController
        } else {
            fatalError("Не описан контроллер \(name)")
        }
    }
}
 
