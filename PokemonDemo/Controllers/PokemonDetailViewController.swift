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
        
        //As soon as the screen is loaded, fetch the backDefault image.
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
        
        //If sprites is nil, there is no need to call getBackDefaultImage
        guard let sprites = self.model?.pokemon?.sprites else {
            hideSegmentControl()
            return
        }
        
        if !(sprites.backDefault ?? "").isEmpty {
            detailViewModel.getBackDefaultImage(imageURL: sprites.backDefault) { (result) in
                switch result {
                case .failure(let error):
                    debugPrint(error)
                    DispatchQueue.main.async {
                        self.hideSegmentControl()
                    }
                    break
                case .success(let image):
                    self.backDefaultImage = image
                    break
                }
            }
        } else {
            hideSegmentControl()
        }
    }
    
    func hideSegmentControl() {
        imageSegmentControl.isHidden = true
        imageSegmentControlHeight.constant = 0
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
        
        //Set Pokemon Height Formatted Value
        heightLabel.text = detailViewModel.getPokemonHeight(height: model?.pokemon?.height)
        heightLabel.font = .detailContentStyle()
        
        weightTitleLabel.text = NSLocalizedString("weight", comment: "")
        weightTitleLabel.font = .detailTitleStyle()
        
        //Set Pokemon Weight Formatted Value
        weightLabel.text = detailViewModel.getPokemonWeight(weight: model?.pokemon?.weight)
        weightLabel.font = .detailContentStyle()
        
        //Set Pokemon Types Views
        detailViewModel.fillPokeTypeInformation(types: model?.pokemon?.types, primaryView: primaryTypeView, secondaryView: secondaryTypeView, primaryLabel: firstTypeLabel, secondaryLabel: secondTypeLabel, typesTitle: typesTitleLabel)
        typesTitleLabel.font = .detailTitleStyle()
    }
    
    override func viewDidLayoutSubviews() {
        updateScrollView()
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
