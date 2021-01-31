//
//  PokemonViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation

public class PokemonListViewModel {
    
    private var serviceAPI = APIService()
    var results = [Results]()
    var cellModels = [PokemonCellViewModel]()
    var hasNext: Bool = true
    
    func fetchPokemons(completion: @escaping () -> Void) {
        serviceAPI.fetchPokemons(with: self.results.count) { (results) in
            switch results {
            case .failure(let error):
                debugPrint(error)
                completion()
                break
                
            case .success(let response):
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
}
