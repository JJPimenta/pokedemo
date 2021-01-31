//
//  ResponseModels.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit

protocol APIServiceProtocol {
    func fetchPokemons(with offset: Int, completion:  @escaping (Result<Response,Error>) -> Void)
    func fetchPokemonDetail(pokeId: String, completion:  @escaping (Result<Pokemon,Error>) -> Void)
    func getPokemonImage(from urlString: String, completion: @escaping (Result<UIImage,Error>) -> Void)
}

public class APIService: APIServiceProtocol {
    
    let limit: String = "100"
    
    ///Used to control if we already reached the end of the API pokemon list
    var next: String = ""
    
    ///Used to retrieve the details of a specific Pokemon.
    /// - Parameters:
    /// - offset: The starting index from the list to called. Should be equal to PokemonListViewModel results.count
    func fetchPokemons(with offset: Int, completion:  @escaping (Result<Response,Error>) -> Void) {
        
        let url = "https://pokeapi.co/api/v2/pokemon?limit=\(limit)&offset=\(offset)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(error!))
                debugPrint(error!)
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                completion(.failure(error))
                debugPrint(error)
            }
            
            guard let decodedResult = result else {
                return
            }
            
            self.next = decodedResult.next ?? ""
            completion(.success(decodedResult))
        }.resume()
    }
    
    ///Used to retrieve the details of a specific Pokemon.
    /// - Parameters:
    /// - pokeId: Pokemon Identifier. Can be either the name or the id.
    func fetchPokemonDetail(pokeId: String, completion:  @escaping (Result<Pokemon,Error>) -> Void) {
        
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
                completion(.failure(error))
                debugPrint(error)
            }
            
            guard let decodedResult = result else {
                return
            }
            
            completion(.success(decodedResult))
        }.resume()
    }

    ///Used to retrieve an image (either front_default or back_default) from a specific pokemon.
    /// - Parameters:
    /// - urlString: The url to get the image from.
    func getPokemonImage(from urlString: String, completion: @escaping (Result<UIImage,Error>) -> Void) {
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
                    } else {
                        let error = NSError(domain: "", code: -1, userInfo: nil)
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: "", code: -1, userInfo: nil)
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}

public struct Response: Codable {
    
    ///Number of total Pokemons in the API List
    var count: Int
    
    ///The next url that contains the next {offset} Pokemons.
    var next: String?
    
    ///Pokemon Objects
    var results: [Results]
}

public struct Results: Codable {
    
    ///Pokemon name
    var name: String
    
    ///Url to get the pokemon detailed information
    var url: String
}
