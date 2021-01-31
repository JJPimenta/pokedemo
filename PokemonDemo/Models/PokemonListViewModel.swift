//
//  PokemonViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit

public class PokemonListViewModel {
    
    private var serviceAPI: APIServiceProtocol
    var results = [Results]()
    var cellModels = [PokemonCellViewModel]()
    var hasNext: Bool = true
    
    var success: Bool = false
    var error: Error?
    
    init (serviceAPI: APIServiceProtocol = APIService()) {
            self.serviceAPI = serviceAPI
    }
    
    func fetchPokemons(completion: @escaping () -> Void) {
        serviceAPI.fetchPokemons(with: self.results.count) { (results) in
            switch results {
            case .failure(let error):
                self.success = false
                self.error = error
                debugPrint(error)
                completion()
                break
            case .success(let response):
                self.success = true
                if (response.next ?? "").isEmpty {
                    self.hasNext = false
                }
                self.results.append(contentsOf: response.results)
                self.createCellViewModels(newResults: response.results, completion: { () in
                    completion()
                })
                break
            }
        }
    }
    
    func createCellViewModels(newResults: [Results], completion: @escaping () -> Void) {
        
        let serviceGroup = DispatchGroup()
        
        for result in newResults {
            let url = URL(string: result.url)
            let pokemonId = url?.pathComponents.last ?? "0"
            let model = PokemonCellViewModel(with: pokemonId)
            self.cellModels.append(model)
            serviceGroup.enter()
            model.downloadPokemonInformation { (result) in
                switch result {
                case .success:
                    serviceGroup.leave()
                    break
                case .failure(let error):
                    debugPrint(error)
                    serviceGroup.leave()
                    break
                }
            }
        }
        
        serviceGroup.notify(queue: DispatchQueue.main) {
            completion()
        }
    }
    
    func fetchPokemon(pokemonName: String, completion: @escaping (Result<SearchedPokemon, Error>) -> Void) {
        serviceAPI.fetchPokemonDetail(pokeId: pokemonName) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                break
            case .success(let pokemon):
                
                guard let frontDefault = pokemon.sprites.frontDefault else {
                    //sprites was nil, so show default image
                    let image = (UIImage(named: "MissingNo.")?.pngData())!
                    let searchedPokemon = SearchedPokemon(pokemon: pokemon, image: image)
                    completion(.success(searchedPokemon))
                    return
                }
                    
                self.serviceAPI.getPokemonImage(from: frontDefault) { (result) in
                    switch result {
                    case .failure:
                        let image = (UIImage(named: "MissingNo.")?.pngData())!
                        let searchedPokemon = SearchedPokemon(pokemon: pokemon, image: image)
                        completion(.success(searchedPokemon))
                        break
                        
                    case .success(let image):
                        let image = image.pngData()!
                        let searchedPokemon = SearchedPokemon(pokemon: pokemon, image: image)
                        completion(.success(searchedPokemon))
                    }
                }
                break
            }
        }
    }
}
