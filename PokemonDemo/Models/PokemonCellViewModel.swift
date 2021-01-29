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
    var pokemonImage: UIImage?
    
    func downloadPokemonInformation(from response: Response, completion: @escaping (Result<Bool,Error>) -> Void) {
        
        // Create the dispatch group
        let serviceGroup = DispatchGroup()
        
        for response in response.results {
            
            let url = URL(string: response.url)
            let pokemonId = url?.pathComponents.last ?? "0"
            
            // Add each service call to the Service Group
            serviceGroup.enter()
            self.fetchPokemonDetail(pokeId: pokemonId) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    // Remove operation from service group
                    serviceGroup.leave()
                    break
                case .success:
                    // Remove operation from service group
                    serviceGroup.leave()
                    break
                }
            }
            
            // When service groups
            serviceGroup.notify(queue: DispatchQueue.main) {
                completion(.success(true))
            }
        }
    }
    
    private func fetchPokemonDetail(pokeId: String, completion:  @escaping (Result<Pokemon,Error>) -> Void) -> Void {
        
        let url = "https://pokeapi.co/api/v2/pokemon/" + pokeId
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                print("Error when obtaing the pokemon details")
                completion(.failure(error!))
                return
            }
            
            var result: Pokemon?
            do {
                result = try JSONDecoder().decode(Pokemon.self, from: data)
            } catch {
                print("Failed to decode object with error: \(error.localizedDescription)")
            }
            
            guard let decodedResult = result else {
                return
            }
            
            self.pokemonId = String(decodedResult.id)
            self.pokemonName = decodedResult.name
            
            self.getPokemonImage(from: decodedResult.sprites.frontDefault) { (result) in
                switch result {
                case .failure:
                    self.pokemonImage = nil
                    completion(.success(decodedResult))
                    break
                    
                case .success(let image):
                    self.pokemonImage = image
                    completion(.success(decodedResult))
                }
            }
        }.resume()
    }
    
    private func getPokemonImage(from urlString: String, completion: @escaping (Result<UIImage,Error>) -> Void) {
        
        let pokemonURL = URL(string: urlString)
        
        URLSession.shared.dataTask(with: pokemonURL!) { (data, response, error) in
            if error != nil {
                completion(.failure(error!))
            } else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        let image = UIImage(data: imageData)
                        completion(.success(image!))
                    }
                }
            }
        }.resume()
    }
}
