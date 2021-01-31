//
//  Pokemon.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit

struct SearchedPokemon {
    var pokemon: Pokemon
    var image: Data
}

struct Pokemon : Codable {
    var id: Int
    var name: String
    var height: Int
    var weight: Int
    var sprites: Sprites
    var types: [Types]?
}

struct Sprites: Codable {
    let frontDefault: String?
    let backDefault: String?

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
        case backDefault = "back_default"
    }
}

struct Types : Codable {
    var slot: Int
    var type: Element
}

struct Element : Codable {
    var name: String
}

struct PokeType {
    enum PokemonType: String {
        case normal
        case fighting
        case flying
        case poison
        case ground
        case rock
        case bug
        case ghost
        case steel
        case fire
        case water
        case grass
        case electric
        case psychic
        case ice
        case dragon
        case dark
        case fairy
        case shadow
        case unknown
    }
    
    func setupTypes(with view: UIView, label: UILabel,for type: PokemonType) {
        
        label.backgroundColor = .clear
        label.text = type.rawValue.capitalized
        label.textColor = .white
        label.font = .detailContentStyle()
        
        view.layer.cornerRadius = 7.0
        
        switch type {
        case .normal:
            view.backgroundColor = .normalTypeColor()
            break
        case .fighting:
            view.backgroundColor = .fightingTypeColor()
            break
        case .flying:
            view.backgroundColor = .flyingTypeColor()
            break
        case .poison:
            view.backgroundColor = .poisonTypeColor()
            break
        case .ground:
            view.backgroundColor = .groundTypeColor()
            break
        case .rock:
            view.backgroundColor = .rockTypeColor()
            break
        case .bug:
            view.backgroundColor = .bugTypeColor()
            break
        case .ghost:
            view.backgroundColor = .ghostTypeColor()
            break
        case .steel:
            view.backgroundColor = .steelTypeColor()
            break
        case .fire:
            view.backgroundColor = .fireTypeColor()
            break
        case .water:
            view.backgroundColor = .waterTypeColor()
            break
        case .grass:
            view.backgroundColor = .grassTypeColor()
            break
        case .electric:
            view.backgroundColor = .electricTypeColor()
            break
        case .psychic:
            view.backgroundColor = .psychicTypeColor()
            break
        case .ice:
            view.backgroundColor = .iceTypeColor()
            break
        case .dragon:
            view.backgroundColor = .dragonTypeColor()
            break
        case .dark:
            view.backgroundColor = .darkTypeColor()
            break
        case .fairy:
            view.backgroundColor = .fairyTypeColor()
            break
        case .shadow:
            view.backgroundColor = .shadowTypeColor()
            break
        case .unknown:
            view.backgroundColor = .unknownTypeColor()
            break
        }
    }
}
