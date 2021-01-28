//
//  PokemonCollectionViewCell.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "pokemonCell"

    @IBOutlet var mainView: UIImageView!
    @IBOutlet var pokemonImageView: UIImageView!
    @IBOutlet var pokemonIdLabel: UILabel!
    @IBOutlet var pokemonNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mainView.backgroundColor = .white
    }
    
    
    
    func configureCell(with cellViewModel: PokemonCellViewModel) {
        pokemonIdLabel.text = cellViewModel.pokemonId
        pokemonNameLabel.text = cellViewModel.pokemonName.capitalized
        pokemonImageView.image = cellViewModel.pokemonImage
    }
}
