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
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var idLabel: UILabel!
    
    @IBOutlet var heightTitleLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    
    @IBOutlet var weightTitleLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    
    @IBOutlet var typesTitleLabel: UILabel!
    @IBOutlet var primaryTypeView: UIView!
    @IBOutlet var firstTypeLabel: UILabel!
    @IBOutlet var secondaryTypeView: UIView!
    @IBOutlet var secondTypeLabel: UILabel!
    
    public var model: PokemonCellViewModel?
    private let detailViewModel = PokemonDetailViewModel()
    private var backDefaultImage = UIImage()
    private var isShowingFrontImage: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBackDefaultImage()
        setupUI()
    }
    
    func initDetailViewController(with model: PokemonCellViewModel) -> PokemonDetailViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newDetail = storyboard.instantiateViewController(identifier: String(describing: PokemonDetailViewController.self)) as? PokemonDetailViewController
        newDetail?.model = model
        return newDetail!
    }
    
    func fetchBackDefaultImage() {
        guard let sprites = self.model?.pokemon?.sprites else {
            return
        }
        
        if !(sprites.backDefault ?? "").isEmpty {
            detailViewModel.getBackDefaultImage(imageURL: sprites.backDefault) { (result) in
                switch result {
                case .failure(let error):
                    debugPrint(error)
                    break
                case .success(let image):
                    self.backDefaultImage = image
                    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTaped))
                    DispatchQueue.main.async {
                        self.imgView.isUserInteractionEnabled = true
                        self.imgView.addGestureRecognizer(tapGesture)
                    }
                    break
                }
            }
        }
    }
    
    func setupUI() {
        
        //Set the UI with the pokemon information
        nameLabel.text = model?.pokemon?.name.capitalized
        nameLabel.font = .detailPokemonNameStyle()
        
        imgView.image = model?.pokemonFrontImage
        
        idLabel.text = ("#\(model?.pokemon?.id ?? 0)")
        idLabel.font = .detailPokemonIdStyle()
        
        heightTitleLabel.text = NSLocalizedString("height", comment: "")
        heightTitleLabel.font = .detailTitleStyle()
        
        //Since pokemon height is decimeters we have to divided it by 10
        let height: Double = Double(model?.pokemon?.height ?? 1) / 10
        heightLabel.text = String(height) + "m"
        heightLabel.font = .detailContentStyle()
        
        weightTitleLabel.text = NSLocalizedString("weight", comment: "")
        weightTitleLabel.font = .detailTitleStyle()
        
        //Since pokemon weight is hectograms we have to divided it by 10
        let weight: Double = Double(model?.pokemon?.weight ?? 1) / 10
        weightLabel.text = String(weight) + "Kg"
        weightLabel.font = .detailContentStyle()
        
        fillPokeTypeInformation()
    }
    
    override func viewDidLayoutSubviews() {
        updateScrollView()
    }
    
    func fillPokeTypeInformation() {
        
        let pokeTypeStruct = PokeType()
        
        let primaryType = PokeType.PokemonType(rawValue: model?.pokemon?.types.first!.type.name ?? "unknown")!
        pokeTypeStruct.setupTypes(with: primaryTypeView, label: firstTypeLabel, for: primaryType)
        
        typesTitleLabel.font = .detailTitleStyle()
        
        if model?.pokemon?.types == nil {
            typesTitleLabel.isHidden = true
            firstTypeLabel.isHidden = true
            secondTypeLabel.isHidden = true
        } else if (model?.pokemon?.types.count)! < 2 {
            typesTitleLabel.text = NSLocalizedString("type", comment: "")
            secondTypeLabel.isHidden = true
        } else {
            typesTitleLabel.text = NSLocalizedString("types", comment: "")
            let secondaryType = PokeType.PokemonType(rawValue: model?.pokemon?.types.last!.type.name ?? "unknown")!
            pokeTypeStruct.setupTypes(with: secondaryTypeView, label: secondTypeLabel, for: secondaryType)
        }
    }
    
    @objc func imageTaped() {
        if isShowingFrontImage {
            isShowingFrontImage = !isShowingFrontImage
            self.imgView.image = self.backDefaultImage
            UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            isShowingFrontImage = !isShowingFrontImage
            self.imgView.image = self.model?.pokemonFrontImage
            UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    @IBAction func closeButtonClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PokemonDetailViewController: UIScrollViewDelegate {
    func updateScrollView() {
        self.scrollViewHeight.constant = typesTitleLabel.frame.maxY + 20
    }
}
