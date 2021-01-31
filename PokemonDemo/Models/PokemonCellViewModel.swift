//
//  PokemonCellViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit

public class PokemonCellViewModel {
    
    var pokemon: Pokemon?
    var pokemonId: String = ""
    var pokemonFrontImage: UIImage?
    let serviceAPI = APIService()
    
    init(with pokemon: Pokemon) {
        self.pokemon = pokemon
    }

    init(with id: String) {
        self.pokemonId = id
    }
    
    func downloadPokemonInformation(completion: @escaping (Result<Pokemon,Error>) -> Void) {
        serviceAPI.fetchPokemonDetail(pokeId: self.pokemonId) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                break
            case .success(let pokemon):
                
                self.pokemon = Pokemon(id: pokemon.id, name: pokemon.name.capitalized, height: pokemon.height, weight: pokemon.weight , sprites: pokemon.sprites, types: pokemon.types)
                
                guard let frontDefault = pokemon.sprites.frontDefault else {
                    self.pokemonFrontImage = UIImage(named: "MissingNo.")
                    completion(.success(pokemon))
                    return
                }
                    
                self.serviceAPI.getPokemonImage(from: frontDefault) { (result) in
                    switch result {
                    case .failure:
                        self.pokemonFrontImage = UIImage(named: "MissingNo.")
                        completion(.success(pokemon))
                        break
                        
                    case .success(let image):
                        self.pokemonFrontImage = image
                        completion(.success(pokemon))
                    }
                }
                break
            }
        }
    }
}
