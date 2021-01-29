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
        imgView.image = model?.pokemonImage
        idLabel.text = ("#\(model?.pokemonId ?? "0")")
        nameLabel.text = model?.pokemonName
        
        var typesString: [String] = []
        for types in model!.pokemonTypes {
            typesString.append(types.type.name.capitalized)
        }
        typesTextLabel.text = typesString.joined(separator: ", ")
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
