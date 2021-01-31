//
//  MockAPIService.swift
//  PokemonDemo
//
//  Created by itsector on 30/01/2021.
//

import UIKit

///This class is exclusively used for the Unit Tests.
class MockAPIService: APIServiceProtocol {
    
    var fetchResult: Result<Response, Error> = .success(Response(count: 100, next: "", results: [Results(name: "Mock Injection", url: "")]))
    var isFetching: Bool = false
    
    func fetchPokemons(with offset: Int, completion: @escaping (Result<Response, Error>) -> Void) {
        isFetching = true
        completion(fetchResult)
    }
    
    func fetchPokemonDetail(pokeId: String, completion: @escaping (Result<Pokemon, Error>) -> Void) { }
    func getPokemonImage(from urlString: String, completion: @escaping (Result<UIImage, Error>) -> Void) { }
}
