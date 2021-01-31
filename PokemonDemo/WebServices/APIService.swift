//
//  ResponseModels.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import Foundation
import UIKit
import SDWebImage

protocol APIServiceProtocol {
    func fetchPokemons(with offset: Int, completion:  @escaping (Result<Response,Error>) -> Void)
}

public class APIService: APIServiceProtocol {
    
    var next: String = ""
    var isFetching = false
    
    func fetchPokemons(with offset: Int, completion:  @escaping (Result<Response,Error>) -> Void) {
        
        //Starting new fetch request. Set control boolean to true to stop multiple requests
        self.isFetching = true
        
        let url = "https://pokeapi.co/api/v2/pokemon?limit=100&offset=" + "\(offset)"
        
        URLSession.shared.dataTask(with: URL(string: url)!) { (data, response, error) in
            
            guard let data = data, error == nil else {
                completion(.failure(error!))
                debugPrint(error!)
                self.isFetching = false
                return
            }
            
            var result: Response?
            do {
                result = try JSONDecoder().decode(Response.self, from: data)
            } catch {
                self.isFetching = false
                completion(.failure(error))
                debugPrint(error)
            }
            
            guard let decodedResult = result else {
                return
            }
            
            self.next = decodedResult.next ?? ""
            self.isFetching = false
            completion(.success(decodedResult))
        }.resume()
    }
    
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
                debugPrint(error)
            }
            
            guard let decodedResult = result else {
                return
            }
            
            completion(.success(decodedResult))
        }.resume()
    }

    func getPokemonImage(from urlString: String, imageView: UIImageView, completion: @escaping (Result<UIImage,Error>) -> Void) {
        let pokemonURL = URL(string: urlString)
        imageView.sd_setImage(with: pokemonURL) { (image, error, nil, url) in
            if let error = error {
                debugPrint(error)
                completion(.failure(error))
            } else {
                completion(.success(image!))
            }
        }
    }
}

public struct Response: Codable {
    var count: Int
    var next: String?
    var results: [Results]
}

public struct Results: Codable {
    var name: String
    var url: String
}
