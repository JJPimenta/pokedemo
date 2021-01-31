//
//  MockAPIService.swift
//  PokemonDemo
//
//  Created by itsector on 30/01/2021.
//

class MockAPIService: APIServiceProtocol {
    
    var fetchResult: Result<Response, Error> = .success(Response(count: 100, next: "", results: [Results(name: "Mock Injection", url: "")]))
    
    var isFetching: Bool = false
    
    func fetchPokemons(with offset: Int, completion: @escaping (Result<Response, Error>) -> Void) {
        isFetching = true
        completion(fetchResult)
    }
}
