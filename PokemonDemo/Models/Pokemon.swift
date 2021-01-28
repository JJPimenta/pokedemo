//
//  Pokemon.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation

public struct Pokemon : Codable {
    var id: Int
    var name: String
    var sprites: Sprites
}

// MARK: - Sprites
struct Sprites: Codable {
    let frontDefault: String

    enum CodingKeys: String, CodingKey {
        case frontDefault = "front_default"
    }
}
