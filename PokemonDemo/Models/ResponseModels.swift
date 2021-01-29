//
//  ResponseModels.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation

public struct Response: Codable {
    var count: Int
    var next: String?
    var previous: String?
    var results: [Results]
}

public struct Results: Codable {
    var name: String
    var url: String
}
