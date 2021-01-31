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
    
    ///Used to control if we are already fetching for more pokemons. This variable will automatically show or hide the loading screen
    private var isServiceAPIFetching: Bool = false {
        didSet {
            if isServiceAPIFetching {
                showActivityView()
            } else {
                hideActivityView()
            }
        }
    }
    
    private var pokemonListViewModel = PokemonListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navBar.topItem?.title = NSLocalizedString("pokemonList.title", comment: "")
        
        collectionView.register(UINib.init(nibName: String(describing: PokemonCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Dismiss keyboard every time the user drags on the collection view
        collectionView.keyboardDismissMode = .onDrag

        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("searchBar.placeholder", comment: "")
        searchBar.barTintColor = .white
        searchBar.backgroundColor = .white
        
        //Used to dismiss the keyboard whenever he taps outside the searchbar
        //Set cancelsTouchesInView set to false so that we can still select an item in the collection view even though the keyboard is showing.
        let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        //Fetch our initial Pokemon List.
        fetchPokemons()
    }
    
    func fetchPokemons() {
        //Show a loading screen whenever we are fetching Pokemon.
        isServiceAPIFetching = true
        pokemonListViewModel.fetchPokemons {
            self.isServiceAPIFetching = false
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func searchPokemonError() {
        DispatchQueue.main.async {
            self.isServiceAPIFetching = false
            
            //No Pokemon was found for the given ID/Name so notify the user
            let title = NSLocalizedString("pokemon.notfound.title", comment: "")
            let message = NSLocalizedString("pokemon.notfound.message", comment: "")
            let buttonTitle = NSLocalizedString("pokemon.notfound.button", comment: "")
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func searchPokemonSuccess(searchResult: SearchedPokemon) {
        
        //Pokemon Found! Go to pokemon detail.
        let model = PokemonCellViewModel(with: searchResult.pokemon)
        model.pokemonFrontImage = UIImage(data: searchResult.image)
        DispatchQueue.main.async {
            self.isServiceAPIFetching = false
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
        
        //Pass the corresponding PokemonCellViewModel
        let model = self.pokemonListViewModel.cellModels[indexPath.row]
        cell?.configureCell(model: model)
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        //Whenever the last cell is about to be shown, fetch for more Pokemons.
        //But first, check if the API has more Pokemons to send.
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
        isServiceAPIFetching = true
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
        self.loadingView.alpha = 0.5
        self.loadingView.isHidden = false
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityView() {
        self.activityIndicator.stopAnimating()
        UIView.animate(withDuration: 0.2, animations: { self.loadingView!.alpha = 0.0 }, completion: nil)
    }
}
