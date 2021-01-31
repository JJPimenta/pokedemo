//
//  PokemonViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit

public class PokemonListViewModel {
    
    //serviceAPI is a APIServiceProtocol for UnitTest purposes
    private var serviceAPI: APIServiceProtocol
    
    ///Used to save all Pokemon that are fetched from the fetchPokemons method
    var results = [Results]()
    
    ///Used to save all PokemonCellViewModels instances to be later used in the PokemonListViewController cellForRow:
    var cellModels = [PokemonCellViewModel]()
    
    ///Boolean used to check if there is another page to be fetched or not
    var hasNext: Bool = true
    
    //Variables used for UnitTest purposes
    var success: Bool = false
    var error: Error?
    
    init (serviceAPI: APIServiceProtocol = APIService()) {
        self.serviceAPI = serviceAPI
    }
    
    ///Ask APIService to fetch the next Pokemon list
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
    
    ///Used to instanciate each CellViewModel and to save them in the cellModels array.
    func createCellViewModels(newResults: [Results], completion: @escaping () -> Void) {
        
        //Dispatch group used to sync all serviceAPI calls and to notify the fetchPokemons method that he can complete his task.
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
    
    ///Method used to retrieve the specific Pokemon information that was search in PokemonListViewController
    func fetchPokemon(pokemonIdentifier: String, completion: @escaping (Result<SearchedPokemon, Error>) -> Void) {
        
        //Before calling serviceAPI, check if we hava already downloaded the searched Pokemon information
        for cellViewModel in cellModels {
            let storedPokemon = cellViewModel.pokemon! as Pokemon
            if storedPokemon.id == Int(pokemonIdentifier) || (storedPokemon.name.lowercased() == pokemonIdentifier.lowercased()) {
                let pokemon = storedPokemon
                let image = (cellViewModel.pokemonFrontImage?.pngData())!
                let searchedPokemon = SearchedPokemon(pokemon: pokemon, image: image)
                completion(.success(searchedPokemon))
                return
            }
        }
        
        //No Pokemon found in cellModels so proceed to fetch
        serviceAPI.fetchPokemonDetail(pokeId: pokemonIdentifier) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                break
            case .success(let pokemon):
                
                guard let frontDefault = pokemon.sprites.frontDefault else {
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
