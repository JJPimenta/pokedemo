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
    var pokemonTypes: [Types] = []
    
    init(with id: String) {
        self.pokemonId = id
    }
    
    func downloadPokemonInformation(completion: @escaping (Result<Pokemon,Error>) -> Void) {
        self.fetchPokemonDetail(pokeId: self.pokemonId) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                break
            case .success(let pokemon):
                completion(.success(pokemon))
                break
            }
        }
    }
    
    private func fetchPokemonDetail(pokeId: String, completion:  @escaping (Result<Pokemon,Error>) -> Void) -> Void {
        
        let url = "https://pokeapi.co/api/v2/pokemon/" + pokeId
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                debugPrint(error!)
                completion(.failure(error!))
                return
            }
            
            var result: Pokemon?
            do {
                result = try JSONDecoder().decode(Pokemon.self, from: data)
            } catch {
                debugPrint(error)
            }
            
            guard let decodedResult = result else {
                return
            }
            
            self.pokemonId = String(decodedResult.id)
            self.pokemonName = decodedResult.name.capitalized
            self.pokemonTypes = decodedResult.types
            
            guard let imgDefault = decodedResult.sprites.frontDefault else {
                //sprites was nil, so show default image
                self.pokemonImage = UIImage(named: "MissingNo.")
                completion(.success(decodedResult))
                return
            }
            
            self.getPokemonImage(from: imgDefault ) { (result) in
                switch result {
                case .failure:
                    self.pokemonImage = UIImage(named: "MissingNo.")
                    completion(.success(decodedResult))
                    break
                    
                case .success(let image):
                    self.pokemonImage = image
                    completion(.success(decodedResult))
                }
            }
        }.resume()
    }
    
    // Retrieve pokemon Image
    private func getPokemonImage(from urlString: String, completion: @escaping (Result<UIImage,Error>) -> Void) {
        let pokemonURL = URL(string: urlString)
        URLSession.shared.dataTask(with: pokemonURL!) { (data, response, error) in
            if error != nil {
                debugPrint(error!)
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
