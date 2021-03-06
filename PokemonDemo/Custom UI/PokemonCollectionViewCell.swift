//
//  PokemonCollectionViewCell.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "pokemonCell"
    
    private var pokemonCellViewModel: PokemonCellViewModel?

    @IBOutlet var mainView: UIImageView!
    @IBOutlet var pokemonImageView: UIImageView!
    @IBOutlet var pokemonIdLabel: UILabel!
    @IBOutlet var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.mainView.backgroundColor = .clear
        
        //Add corner radius to custom cell
        self.contentView.layer.cornerRadius = 10
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true

        //Add shadow effect to custom cell
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.7
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
        pokemonNameLabel.font = .listPokemonNameStyle()
    }
    
    ///Used to populate each PokemonCollectionViewCell
    ///- Parameters:
    ///- model: the corresponding PokemonCellViewModel
    func configureCell(model: PokemonCellViewModel) {
        pokemonIdLabel.text = "#" + model.pokemonId
        pokemonNameLabel.text = model.pokemon?.name.capitalized
        pokemonImageView.image = model.pokemonFrontImage
    }
}
