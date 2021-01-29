//
//  Pokemon.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation

struct Pokemon : Codable {
    var id: Int
    var name: String
    var sprites: Sprites
    var types: [Types]
}

struct Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}

struct Types : Codable {
    var slot: Int
    var type: Element
}

struct Element : Codable {
    var name: String
}
