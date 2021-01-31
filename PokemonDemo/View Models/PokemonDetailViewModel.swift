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
    
    ///Method used to ask serviceAPI to download the Pokemon back image
    ///- Parameters:
    ///- imageURL: The URL of the back_default property from the Pokemon presented in the PokemonDetailViewController
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
    
    func getPokemonHeight(height: Int?) -> String {
        if height == nil {
            return NSLocalizedString("noheight", comment: "")
        }
        
        //Since pokemon height is decimeters we have to divided it by 10
        let h = Double(height ?? 0) / 10
        return String(h) + "m"
    }
    
    func getPokemonWeight(weight: Int?) -> String {
        if weight == nil {
            return NSLocalizedString("noweight", comment: "")
        }
        
        //Since pokemon weight is hectograms we have to divided it by 10
        let w = Double(weight ?? 0) / 10
        return String(w) + "m"
    }
    
    func fillPokeTypeInformation(types: [Types]?, primaryView: UIView, secondaryView: UIView, primaryLabel: UILabel, secondaryLabel: UILabel, typesTitle: UILabel) {
        
        let pokeTypeStruct = PokeType()
        
        if types == nil {
            typesTitle.isHidden = true
            primaryView.isHidden = true
            secondaryView.isHidden = true
        } else if types?.count == 1 {
            typesTitle.text = NSLocalizedString("type", comment: "")
            
            let primaryType = PokeType.PokemonType(rawValue: types?.first!.type.name ?? "unknown")!
            pokeTypeStruct.setupTypes(with: primaryView, label: primaryLabel, for: primaryType)
            
            secondaryView.isHidden = true
        } else {
            typesTitle.text = NSLocalizedString("types", comment: "")
            
            let primaryType = PokeType.PokemonType(rawValue: types?.first!.type.name ?? "unknown")!
            pokeTypeStruct.setupTypes(with: primaryView, label: primaryLabel, for: primaryType)
            
            let secondaryType = PokeType.PokemonType(rawValue: types?.last!.type.name ?? "unknown")!
            pokeTypeStruct.setupTypes(with: secondaryView, label: secondaryLabel, for: secondaryType)
        }
    }
}

struct PokeType {
    enum PokemonType: String {
        case normal
        case fighting
        case flying
        case poison
        case ground
        case rock
        case bug
        case ghost
        case steel
        case fire
        case water
        case grass
        case electric
        case psychic
        case ice
        case dragon
        case dark
        case fairy
        case shadow
        case unknown
    }
    
    func setupTypes(with view: UIView, label: UILabel,for type: PokemonType) {
        
        label.backgroundColor = .clear
        label.text = type.rawValue.capitalized
        label.textColor = .white
        label.font = .detailContentStyle()
        
        view.layer.cornerRadius = 7.0
        
        switch type {
        case .normal:
            view.backgroundColor = .normalTypeColor()
            break
        case .fighting:
            view.backgroundColor = .fightingTypeColor()
            break
        case .flying:
            view.backgroundColor = .flyingTypeColor()
            break
        case .poison:
            view.backgroundColor = .poisonTypeColor()
            break
        case .ground:
            view.backgroundColor = .groundTypeColor()
            break
        case .rock:
            view.backgroundColor = .rockTypeColor()
            break
        case .bug:
            view.backgroundColor = .bugTypeColor()
            break
        case .ghost:
            view.backgroundColor = .ghostTypeColor()
            break
        case .steel:
            view.backgroundColor = .steelTypeColor()
            break
        case .fire:
            view.backgroundColor = .fireTypeColor()
            break
        case .water:
            view.backgroundColor = .waterTypeColor()
            break
        case .grass:
            view.backgroundColor = .grassTypeColor()
            break
        case .electric:
            view.backgroundColor = .electricTypeColor()
            break
        case .psychic:
            view.backgroundColor = .psychicTypeColor()
            break
        case .ice:
            view.backgroundColor = .iceTypeColor()
            break
        case .dragon:
            view.backgroundColor = .dragonTypeColor()
            break
        case .dark:
            view.backgroundColor = .darkTypeColor()
            break
        case .fairy:
            view.backgroundColor = .fairyTypeColor()
            break
        case .shadow:
            view.backgroundColor = .shadowTypeColor()
            break
        case .unknown:
            view.backgroundColor = .unknownTypeColor()
            break
        }
    }
}
