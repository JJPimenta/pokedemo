//
//  Extensions.swift
//  PokemonDemo
//
//  Created by itsector on 30/01/2021.
//

import Foundation
import UIKit

extension UIColor {
    class func normalTypeColor() -> UIColor {
        return UIColor(red: 168/255, green: 167/255, blue: 125/255, alpha: 1)
    }
    
    class func fightingTypeColor() -> UIColor {
        return UIColor(red: 177/255, green: 61/255, blue: 49/255, alpha: 1)
    }
    
    class func flyingTypeColor() -> UIColor {
        return UIColor(red: 163/255, green: 147/255, blue: 234/255, alpha: 1.0)
    }
    
    class func poisonTypeColor() -> UIColor {
        return UIColor(red: 148/255, green: 72/255, blue: 155/255, alpha: 1.0)
    }
    
    class func groundTypeColor() -> UIColor {
        return UIColor(red: 219/255, green: 192/255, blue: 117/255, alpha: 1.0)
    }
    
    class func rockTypeColor() -> UIColor {
        return UIColor(red: 180/255, green: 160/255, blue: 75/255, alpha: 1.0)
    }
    
    class func bugTypeColor() -> UIColor {
        return UIColor(red: 171/255, green: 182/255, blue: 66/255, alpha: 1.0)
    }
    
    class func ghostTypeColor() -> UIColor {
        return UIColor(red: 108/255, green: 90/255, blue: 148/255, alpha: 1.0)
    }
    
    class func steelTypeColor() -> UIColor {
        return UIColor(red: 184/255, green: 184/255, blue: 206/255, alpha: 1.0)
    }
    
    class func fireTypeColor() -> UIColor {
        return UIColor(red: 226/255, green: 133/255, blue: 68/255, alpha: 1.0)
    }
    
    class func waterTypeColor() -> UIColor {
        return UIColor(red: 111/255, green: 145/255, blue: 233/255, alpha: 1.0)
    }
    
    class func grassTypeColor() -> UIColor {
        return UIColor(red: 139/255, green: 197/255, blue: 96/255, alpha: 1.0)
    }
    
    class func electricTypeColor() -> UIColor {
        return UIColor(red: 243/255, green: 208/255, blue: 84/255, alpha: 1.0)
    }
    
    class func psychicTypeColor() -> UIColor {
        return UIColor(red: 230/255, green: 100/255, blue: 136/255, alpha: 1.0)
    }
    
    class func iceTypeColor() -> UIColor {
        return UIColor(red: 166/255, green: 214/255, blue: 215/255, alpha: 1.0)
    }
    
    class func dragonTypeColor() -> UIColor {
        return UIColor(red: 103/255, green: 68/255, blue: 239/255, alpha: 1.0)
    }
    
    class func darkTypeColor() -> UIColor {
        return UIColor(red: 108/255, green: 89/255, blue: 74/255, alpha: 1.0)
    }
    
    class func fairyTypeColor() -> UIColor {
        return UIColor(red: 226/255, green: 147/255, blue: 172/255, alpha: 1.0)
    }
    
    class func shadowTypeColor() -> UIColor {
        return .black
    }
    
    class func unknownTypeColor() -> UIColor {
        return UIColor(red: 117/255, green: 159/255, blue: 145/255, alpha: 1.0)
    }
}

extension UIFont {
    class func detailTitleStyle() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .bold)
    }
    
    class func detailContentStyle() -> UIFont {
        return UIFont.systemFont(ofSize: 17.0, weight: .medium)
    }
    
    class func detailPokemonNameStyle() -> UIFont {
        return UIFont.systemFont(ofSize: 28.0, weight: .heavy)
    }
    
    class func detailPokemonIdStyle() -> UIFont {
        return UIFont.systemFont(ofSize: 19.0, weight: .bold)
    }
}
