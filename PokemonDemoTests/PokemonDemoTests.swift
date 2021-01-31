//
//  PokemonDemoTests.swift
//  PokemonDemoTests
//
//  Created by itsector on 28/01/2021.
//

import XCTest
@testable import PokemonDemo

class PokemonDemoTests: XCTestCase {

    var mockService = MockAPIService()
    var pokemonListViewModel: PokemonListViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        pokemonListViewModel = PokemonListViewModel(serviceAPI: mockService)
    }
    
    func testIsFetching() {
        pokemonListViewModel.fetchPokemons { }
        XCTAssertTrue(mockService.isFetching)
    }
    
    func testFetchSuccessful() {
        mockService.fetchResult = .success(Response(count: 1, next: "", results: [Results(name: "Mock Injection", url: "")]))
        pokemonListViewModel.fetchPokemons { }
        XCTAssertTrue(pokemonListViewModel.success)
    }
    
    func testFetchFailed() {
        mockService.fetchResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        pokemonListViewModel.fetchPokemons { }
        XCTAssertNotNil(pokemonListViewModel.error)
    }
}
