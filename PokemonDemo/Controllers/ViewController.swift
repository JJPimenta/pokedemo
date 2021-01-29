//
//  ViewController.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var pokemonListViewModel = PokemonListViewModel()
    private var pokemonCellViewModel: PokemonCellViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.register(UINib.init(nibName: String(describing: PokemonCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPokemons()
    }
    
    func fetchPokemons() {
        //self.showActivityView()
        let index = self.pokemonListViewModel.results.count
        pokemonListViewModel.fetchPokemons(with: index) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                //self.hideActiviyView()
                break
            case .success:
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                break
            }
        }
    }
}

// MARK: UICollectionView Extensions
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsViewController = self.storyboard?.instantiateViewController(withIdentifier: "PokemonDetailViewController") as! PokemonDetailViewController
        detailsViewController.model = self.pokemonListViewModel.cellModels[indexPath.row]
        self.present(detailsViewController, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonListViewModel.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell
        
        let model = self.pokemonListViewModel.cellModels[indexPath.row]
        cell?.configureCell(model: model)
        return cell!
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        // Check if we should fetch more data
        if offset > (self.collectionView.contentSize.height - (scrollView.frame.height)) {
            
            //So we don't get multiple calls
            guard !self.pokemonListViewModel.isFetching else {
                return
            }
            
            fetchPokemons()
        }
    }
}
