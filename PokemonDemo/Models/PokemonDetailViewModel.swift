//
//  PokemonDetailViewModel.swift
//  PokemonDemo
//
//  Created by itsector on 31/01/2021.
//

import Foundation
import UIKit

public class PokemonDetailViewModel {
    
    private var serviceAPI: APIServiceProtocol
    
    init (serviceAPI: APIServiceProtocol = APIService()) {
        self.serviceAPI = serviceAPI
    }
    
    func getBackDefaultImage(imageURL: String!, completion: @escaping (Result<UIImage, Error>) -> Void) {
        serviceAPI.getPokemonImage(from: imageURL) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                completion(.failure(error))
                break
            case .success(let image):
                completion(.success(image))
                break
            }
        }
    }
}
