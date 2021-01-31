//
//  PokemonCellViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit

public class PokemonCellViewModel {
    
    var pokemonId: String = ""
    var pokemonName: String = ""
    var pokemonHeight: Int = 0
    var pokemonWeight: Int = 0
    var pokemonImage: UIImage?
    var pokemonTypes: [Types] = []
    let serviceAPI = APIService()
    
    required init(id: String, name: String, height: Int, weight: Int, image: UIImage, types: [Types]) {
        self.pokemonId = id
        self.pokemonName = name
        self.pokemonHeight = height
        self.pokemonWeight = weight
        self.pokemonImage = image
        self.pokemonTypes = types
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
                self.pokemonId = String(pokemon.id)
                self.pokemonName = pokemon.name.capitalized
                self.pokemonHeight = pokemon.height
                self.pokemonWeight = pokemon.weight
                self.pokemonTypes = pokemon.types
                    
                guard let frontDefault = pokemon.sprites.frontDefault else {
                    self.pokemonImage = UIImage(named: "MissingNo.")
                    completion(.success(pokemon))
                    return
                }
                    
                self.serviceAPI.getPokemonImage(from: frontDefault) { (result) in
                    switch result {
                    case .failure:
                        self.pokemonImage = UIImage(named: "MissingNo.")
                        completion(.success(pokemon))
                        break
                        
                    case .success(let image):
                        self.pokemonImage = image
                        completion(.success(pokemon))
                    }
                }
                break
            }
        }
    }
}
