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
    @IBOutlet var imageSegmentControl: UISegmentedControl!
    @IBOutlet var imageSegmentControlHeight: NSLayoutConstraint!
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
            imageSegmentControl.isHidden = true
            imageSegmentControlHeight.constant = 0
            return
        }
        
        if !(sprites.backDefault ?? "").isEmpty {
            detailViewModel.getBackDefaultImage(imageURL: sprites.backDefault) { (result) in
                switch result {
                case .failure(let error):
                    debugPrint(error)
                    DispatchQueue.main.async {
                        self.imageSegmentControl.isHidden = true
                        self.imageSegmentControlHeight.constant = 0
                    }
                    break
                case .success(let image):
                    self.backDefaultImage = image
                    break
                }
            }
        } else {
            imageSegmentControl.isHidden = true
            imageSegmentControlHeight.constant = 0
        }
    }
    
    func setupUI() {
        
        //Set the UI with the pokemon information
        nameLabel.text = model?.pokemon?.name.capitalized
        nameLabel.font = .detailPokemonNameStyle()
        
        imgView.image = model?.pokemonFrontImage
        
        imageSegmentControl.setTitle(NSLocalizedString("frontImage", comment: ""), forSegmentAt: 0)
        imageSegmentControl.setTitle(NSLocalizedString("backImage", comment: ""), forSegmentAt: 1)
        
        idLabel.text = ("#\(model?.pokemon?.id ?? 0)")
        idLabel.font = .detailPokemonIdStyle()
        
        heightTitleLabel.text = NSLocalizedString("height", comment: "")
        heightTitleLabel.font = .detailTitleStyle()
        
        //Since pokemon height is decimeters we have to divided it by 10
        let height: Double = Double(model?.pokemon?.height ?? 0) / 10
        heightLabel.text = String(height) + "m"
        heightLabel.font = .detailContentStyle()
        
        weightTitleLabel.text = NSLocalizedString("weight", comment: "")
        weightTitleLabel.font = .detailTitleStyle()
        
        //Since pokemon weight is hectograms we have to divided it by 10
        let weight: Double = Double(model?.pokemon?.weight ?? 0) / 10
        weightLabel.text = String(weight) + "Kg"
        weightLabel.font = .detailContentStyle()
        
        fillPokeTypeInformation()
    }
    
    override func viewDidLayoutSubviews() {
        updateScrollView()
    }
    
    func fillPokeTypeInformation() {
        
        let pokeTypeStruct = PokeType()
        
        let primaryType = PokeType.PokemonType(rawValue: model?.pokemon?.types?.first!.type.name ?? "unknown")!
        pokeTypeStruct.setupTypes(with: primaryTypeView, label: firstTypeLabel, for: primaryType)
        
        typesTitleLabel.font = .detailTitleStyle()
        
        if model?.pokemon?.types == nil {
            typesTitleLabel.isHidden = true
            primaryTypeView.isHidden = true
            secondaryTypeView.isHidden = true
        } else if (model?.pokemon?.types?.count)! < 2 {
            typesTitleLabel.text = NSLocalizedString("type", comment: "")
            secondaryTypeView.isHidden = true
        } else {
            typesTitleLabel.text = NSLocalizedString("types", comment: "")
            let secondaryType = PokeType.PokemonType(rawValue: model?.pokemon?.types?.last!.type.name ?? "unknown")!
            pokeTypeStruct.setupTypes(with: secondaryTypeView, label: secondTypeLabel, for: secondaryType)
        }
    }
    
    @IBAction func segmentControlClicked(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.imgView.image = self.model?.pokemonFrontImage
            UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            break
            
        case 1:
            self.imgView.image = self.backDefaultImage
            UIView.transition(with: imgView, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            break
        default:
            break
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
