//
//  PokemonDetailViewController.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class PokemonDetailViewController: UIViewController {
    
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    
    @IBOutlet var heightTitleLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    
    @IBOutlet var weightTitleLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    @IBOutlet var typesTitleLabel: UILabel!
    @IBOutlet var primaryTypeView: UIView!
    @IBOutlet var firstTypeLabel: UILabel!
    @IBOutlet var secondaryTypeView: UIView!
    @IBOutlet var secondTypeLabel: UILabel!
    
    public var model: PokemonCellViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        
        //Set the UI with the pokemon information
        nameLabel.text = model?.pokemonName
        nameLabel.font = UIFont.systemFont(ofSize: nameLabel.font.pointSize, weight: .heavy)
        
        imgView.image = model?.pokemonImage
        
        idLabel.text = ("#\(model?.pokemonId ?? "0")")
        idLabel.font = UIFont.systemFont(ofSize: idLabel.font.pointSize, weight: .bold)
        
        heightTitleLabel.text = NSLocalizedString("height", comment: "")
        heightTitleLabel.font = .detailTitleStyle()
        
        //Since pokemon height is decimeters we have to divided it by 10
        let height: Double = Double(model!.pokemonHeight) / 10
        heightLabel.text = String(height) + "m"
        heightLabel.font = .detailContentStyle()
        
        
        weightTitleLabel.text = NSLocalizedString("weight", comment: "")
        weightTitleLabel.font = .detailTitleStyle()
        
        //Since pokemon weight is hectograms we have to divided it by 10
        let weight: Double = Double(model!.pokemonWeight) / 10
        weightLabel.text = String(weight) + "Kg"
        weightLabel.font = .detailContentStyle()
        
        
        fillPokeTypeInformation()
    }
    
    override func viewDidLayoutSubviews() {
        updateScrollView()
    }
    
    func fillPokeTypeInformation() {
        
        let pokeTypeStruct = PokeType()
        
        let primaryType = PokeType.PokemonType(rawValue: model!.pokemonTypes.first!.type.name)!
        pokeTypeStruct.setupTypes(with: primaryTypeView, label: firstTypeLabel, for: primaryType)
        
        typesTitleLabel.font = .detailTitleStyle()
        
        if model!.pokemonTypes.count < 2 {
            typesTitleLabel.text = NSLocalizedString("type", comment: "")
            secondTypeLabel.isHidden = true
        } else {
            typesTitleLabel.text = NSLocalizedString("types", comment: "")
            let secondaryType = PokeType.PokemonType(rawValue: model!.pokemonTypes.last!.type.name)!
            pokeTypeStruct.setupTypes(with: secondaryTypeView, label: secondTypeLabel, for: secondaryType)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PokemonDetailViewController: UIScrollViewDelegate {
    func updateScrollView() {
        self.scrollViewHeight.constant = typesTitleLabel.frame.maxY + 20
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
