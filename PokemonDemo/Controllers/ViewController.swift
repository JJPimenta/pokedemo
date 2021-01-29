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
        self.showActivityView()
        let index = self.pokemonListViewModel.results.count
        pokemonListViewModel.fetchPokemons(with: index) { (result) in
            switch result {
            case .failure(let error):
                print(error)
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let lastRowIndex = collectionView.numberOfItems(inSection: 0) - 1
        
        if indexPath.row == lastRowIndex && !self.pokemonListViewModel.isFetching {
            fetchPokemons()
        }
    }
}

// MARK: Utility Methods Extension
extension ViewController {
    
    func showActivityView() {
        let loadingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        loadingView.backgroundColor = .black
        loadingView.layer.opacity = 0.5
        
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.color = .white
        activityIndicator.style = .large
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()
        
        loadingView.addSubview(activityIndicator)
        self.view.addSubview(loadingView)
    }
    
    func hideActivityView() {
        let loadingView = self.view.subviews.last
        UIView.animate(withDuration: 0.2, animations: {
            loadingView!.alpha = 0.0
            }, completion: { (finished: Bool) in
                loadingView!.removeFromSuperview()
        })
    }
}
