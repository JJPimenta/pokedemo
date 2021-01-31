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
    
    init(with pokemon: Pokemon) {
        self.id = pokemon.id
        self.name = pokemon.name
        self.height = pokemon.height
        self.weight = pokemon.weight
        self.sprites = pokemon.sprites
        self.types = pokemon.types
    }
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
