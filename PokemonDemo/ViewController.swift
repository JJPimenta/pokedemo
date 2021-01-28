//
//  ViewController.swift
//  PokemonDemo
//
//  Created by itsector on 28/01/2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    private var pokemonListViewModel = PokemonListViewModel()
    private var pokemonCellViewModel = PokemonCellViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "PokemonDemo"
        
        collectionView.register(UINib.init(nibName: String(describing: PokemonCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: PokemonCollectionViewCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.activityView.startAnimating()
        pokemonListViewModel.fetchPokemons(with: 0) { (result) in
            switch result {
            case .failure(let error):
                print(error)
                break
            case .success(let results):
                
                self.pokemonCellViewModel.downloadPokemonInformation(from: results)
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                break
            }
        }
    }
}

// MARK: UICollectionView Extensions
extension ViewController: UICollectionViewDelegate {}
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemonListViewModel.results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCollectionViewCell.identifier, for: indexPath) as? PokemonCollectionViewCell
        cell?.backgroundColor = .orange
        return cell!
    }
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        
        // Check if we should fetch more data
        if offset > (self.collectionView.contentSize.height - scrollView.frame.height - 150) {
            
            //So we don't get multiple calls
            guard !self.pokemonListViewModel.isFetching else {
                return
            }
            
            self.pokemonListViewModel.fetchPokemons(with: self.pokemonListViewModel.results.count) { (results) in
                
                switch results {
                case .success:
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                    break
                case .failure(let error):
                    print(error)
                    break
                }
            }
        }
    }
}
