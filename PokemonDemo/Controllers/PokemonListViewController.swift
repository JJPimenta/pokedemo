//
//  PokemonListViewController.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class PokemonListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    private var pokemonListViewModel = PokemonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.register(UINib.init(nibName: String(describing: PokemonCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        fetchPokemons()
    }
    
    func fetchPokemons() {
        self.showActivityView()
        let index = self.pokemonListViewModel.results.count
        pokemonListViewModel.fetchPokemons(with: index) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                self.hideActivityView()
                break
            case .success:
                DispatchQueue.main.async {
                    self.hideActivityView()
                    self.collectionView.reloadData()
                }
                break
            }
        }
    }
}

// MARK: UICollectionView Extensions
extension PokemonListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model =  self.pokemonListViewModel.cellModels[indexPath.row]
        let vc = PokemonDetailViewController().initDetailViewController(with: model)
        self.present(vc, animated: true, completion: nil)
    }
}

extension PokemonListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonListViewModel.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell
        
        let model = self.pokemonListViewModel.cellModels[indexPath.row]
        cell?.configureCell(model: model)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if self.pokemonListViewModel.next.isEmpty {
            return
        }
        
        if indexPath.row == lastRowIndex && !self.pokemonListViewModel.isFetching {
            fetchPokemons()
        }
    }
}

// MARK: Utility Methods Extension
extension PokemonListViewController {
    func showActivityView() {
        self.loadingView.alpha = 0.5
        self.loadingView.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityView() {
        self.activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView!.alpha = 0.0
            }, completion: { (finished: Bool) in
                
        })
    }
}
