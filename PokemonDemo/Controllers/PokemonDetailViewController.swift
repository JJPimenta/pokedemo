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
    @IBOutlet var pokemonImageView: UIImageView!
    @IBOutlet var pokemonIdLabel: UILabel!
    @IBOutlet var pokemonNameLabel: UILabel!
    @IBOutlet var pokemonDescriptionTitle: UILabel!
    @IBOutlet var pokemonDescriptionText: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        updateScrollView()
    }
    
}

extension PokemonDetailViewController: UIScrollViewDelegate {
    func updateScrollView() {
        self.scrollViewHeight.constant = scrollView.subviews.last?.frame.maxY ?? 0 + 20
    }
}
