//
//  PokemonViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation

public class PokemonListViewModel {
    
    var cellModels = [PokemonCellViewModel]()
    var results = [Results]()
    var isFetching = false
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon?limit=50&offset="
    
    func fetchPokemons(with offset: Int, completion:  @escaping (Result<Response,Error>) -> Void) -> Void {
        
        //Starting new fetch request. Set control boolean to true to stop multiple requests
        self.isFetching = true
                
        let url = baseURL + "\(offset)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Error when obtaing inicial pokemon list")
                completion(.failure(error!))
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                print("Failed to decode object with error: \(error.localizedDescription)")
            }
            
            guard let decodedResult = result else {
                return
            }
            
            self.results.append(contentsOf: decodedResult.results)
            self.createCellViewModels(newResults: decodedResult.results, completion: { () in
                completion(.success(decodedResult))
            })
            
            //Fetching just ended, reset to false
            self.isFetching = false
            
        }.resume()
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
                    print(error.localizedDescription)
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
