//
//  ResponseModels.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation

public struct Response: Codable {
    
    ///Number of total Pokemon count
    var count: Int
    
    ///URL for the next page on the list
    var next: String
    
    ///URL for the previous  page on the list
    var previous: String?
    
    ///List of pokemons
    var results: [Results]
    
}

public struct Results: Codable {
    var name: String
    var url: String
}
