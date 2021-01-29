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
        mainView.backgroundColor = .white
    }
    
    func configureCell(model: PokemonCellViewModel) {
        pokemonIdLabel.text = "#" + model.pokemonId
        pokemonNameLabel.text = model.pokemonName
        pokemonImageView.image = model.pokemonImage
    }
}
