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
        nameLabel.font = .detailTitleStyle()
        
        imgView.image = model?.pokemonImage
        
        idLabel.text = ("#\(model?.pokemonId ?? "0")")
        idLabel.font = .detailPokemonIdStyle()
        
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
