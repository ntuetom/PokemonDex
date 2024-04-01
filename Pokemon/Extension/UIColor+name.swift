//
//  UIColor+name.swift
//  Pokemon
//
//  Created by Wu hung-yi on 2024/4/1.
//

import UIKit

extension UIColor {
    public func named(_ name: String) -> UIColor? {
        switch name {
        case "gray":
            return UIColor.gray
        case "pink":
            return UIColor.systemPink
        case "purple":
            return UIColor.purple
        case "red":
            return UIColor.red
        case "blue":
            return UIColor.blue
        case "brown":
            return UIColor.brown
        case "green":
            return UIColor.green
        case "yellow":
            return UIColor.yellow
        case "black":
            return UIColor.black
        default :
            return UIColor.white
        }
    }
}
