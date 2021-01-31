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
    
    ///Get Pokemon details
    func downloadPokemonInformation(completion: @escaping (Result<Pokemon,Error>) -> Void) {
        serviceAPI.fetchPokemonDetail(pokeId: self.pokemonId) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                break
            case .success(let pokemon):
                
                self.pokemon = Pokemon(with: pokemon)
                
                //If frontDefault is nil, set the MissingNo. directly
                guard let frontDefault = pokemon.sprites.frontDefault else {
                    self.pokemonFrontImage = UIImage(named: "MissingNo.")
                    completion(.success(pokemon))
                    return
                }
                
                //Use the frontDefault URL to retrieve the pokemon image and save it
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
