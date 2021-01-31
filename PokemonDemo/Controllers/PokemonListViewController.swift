//
//  PokemonListViewController.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class PokemonListViewController: UIViewController {

    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var loadingView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    private var isServiceAPIFetching: Bool = false
    private var pokemonListViewModel = PokemonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navBar.topItem?.title = NSLocalizedString("pokemonList.title", comment: "")
        
        collectionView.register(UINib.init(nibName: String(describing: PokemonCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.keyboardDismissMode = .onDrag

        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("searchBar.placeholder", comment: "")
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        fetchPokemons()
    }
    
    func fetchPokemons() {
        self.showActivityView()
        pokemonListViewModel.fetchPokemons {
            self.hideActivityView()
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchPokemonError() {
        DispatchQueue.main.async {
            self.hideActivityView()
            let title = NSLocalizedString("pokemon.notfound.title", comment: "")
            let message = NSLocalizedString("pokemon.notfound.message", comment: "")
            let buttonTitle = NSLocalizedString("pokemon.notfound.button", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchPokemonSuccess(searchResult: SearchedPokemon) {
        let model = PokemonCellViewModel(with: searchResult.pokemon)
        model.pokemonFrontImage = UIImage(data: searchResult.image)
        DispatchQueue.main.async {
            self.hideActivityView()
            let vc = PokemonDetailViewController().initDetailViewController(with: model)
            self.present(vc, animated: true, completion: nil)
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
        
        if !self.pokemonListViewModel.hasNext {
            return
        }
        
        if indexPath.row == lastRowIndex && !self.isServiceAPIFetching {
            fetchPokemons()
        }
    }
}

// MARK: SearchBar Extension
extension PokemonListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.showActivityView()
        pokemonListViewModel.fetchPokemon(pokemonIdentifier: (searchBar.text?.lowercased())!) { (result) in
            switch result {
            case .failure(let error):
                debugPrint(error)
                self.searchPokemonError()
                break
            case .success(let searchResult):
                self.searchPokemonSuccess(searchResult: searchResult)
                break
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}


// MARK: Utility Methods Extension
extension PokemonListViewController {
    func showActivityView() {
        
        self.isServiceAPIFetching = true
        
        self.loadingView.alpha = 0.5
        self.loadingView.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityView() {
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView!.alpha = 0.0
            }, completion: { (finished: Bool) in
                self.isServiceAPIFetching = false
        })
    }
}
