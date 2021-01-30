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
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typesTitleLabel: UILabel!
    @IBOutlet var typesTextLabel: UILabel!
    
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
        
        typesTitleLabel.text = NSLocalizedString("height", comment: "") + ":"
        typesTitleLabel.font = UIFont.systemFont(ofSize: typesTitleLabel.font.pointSize, weight: .semibold)
        
        var typesString: [String] = []
        for types in model!.pokemonTypes {
            typesString.append(types.type.name.capitalized)
        }
        typesTextLabel.text = typesString.joined(separator: ", ")
        typesTextLabel.font = UIFont.systemFont(ofSize: typesTextLabel.font.pointSize, weight: .regular)
    }
    
    override func viewDidLayoutSubviews() {
        updateScrollView()
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PokemonDetailViewController: UIScrollViewDelegate {
    func updateScrollView() {
        self.scrollViewHeight.constant = scrollView.subviews.last?.frame.maxY ?? 0 + 20
    }
}
