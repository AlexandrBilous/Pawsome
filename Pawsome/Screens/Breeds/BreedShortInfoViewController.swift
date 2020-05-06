//
//  BreedShortInfoViewController.swift
//  Pawsome
//
//  Created by Marentilo on 05.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class BreedShortInfoViewController : UIViewController {
    private let breedViewModel : BreedViewModel
    private let detailsView = UIView()
    private let catImageView = UIImageView()
    private let breedDescriptionLabel = Label.makeTextLabel()
    private let breedNameLabel = Label.makeTitleLabel()
    private let originLabel = Label.makeSubtitleLabel(with: Strings.origin)
    private let originDetailLabel = Label.makeTitleLabel()
    private let intelligenceLabel = Label.makeSubtitleLabel(with: Strings.intelligence)
    private let intelligenceDetailLabel = Label.makeTitleLabel()
    private let socialNeedsLabel = Label.makeSubtitleLabel(with: Strings.socialNeeds)
    private let socialNeedsDetailLabel = Label.makeTitleLabel()
    
    
    init(breedMViewModel : BreedViewModel) {
        self.breedViewModel = breedMViewModel
        super.init(nibName: nil, bundle : nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        configure()
    }
    
    private func setupView() {
        view.makeBlur()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(screenDidTap(sender:))))
        view.addSubview(detailsView)
        
        detailsView.roundCorners(radius: StyleGuide.CornersRadius.largeView)
        detailsView.makeShadow()
        detailsView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        breedDescriptionLabel.font = breedDescriptionLabel.font.withSize(18)
        
        [
            catImageView,
            breedDescriptionLabel,
            breedNameLabel,
            originLabel,
            originDetailLabel,
            socialNeedsLabel,
            socialNeedsDetailLabel,
            intelligenceLabel,
            intelligenceDetailLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            detailsView.addSubview($0)
        }
        [originDetailLabel, socialNeedsDetailLabel, intelligenceDetailLabel].forEach {
            $0.font = UIFont.boldSystemFont(ofSize: 20)
            
        }
        setupConstrains()
    }
    
    private func setupConstrains() {
        let viewWidth = view.bounds.width - StyleGuide.Spaces.single * 2
        let imageHeight = viewWidth / 2
        
        let constrains = [
            detailsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: StyleGuide.Spaces.single),
            detailsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -StyleGuide.Spaces.single),
            detailsView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            
            catImageView.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: StyleGuide.Spaces.single),
            catImageView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -StyleGuide.Spaces.single),
            catImageView.heightAnchor.constraint(equalToConstant: imageHeight),
            catImageView.widthAnchor.constraint(equalToConstant: imageHeight),
            
            breedNameLabel.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: StyleGuide.Spaces.double),
            breedNameLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: StyleGuide.Spaces.double),
            breedNameLabel.trailingAnchor.constraint(equalTo: catImageView.leadingAnchor, constant: -StyleGuide.Spaces.single),
            
            originLabel.topAnchor.constraint(equalTo: breedNameLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            originLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            originDetailLabel.bottomAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: 0),
            originDetailLabel.leadingAnchor.constraint(equalTo: originLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            intelligenceLabel.topAnchor.constraint(equalTo: originLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            intelligenceLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            intelligenceDetailLabel.bottomAnchor.constraint(equalTo: intelligenceLabel.bottomAnchor, constant: 0),
            intelligenceDetailLabel.leadingAnchor.constraint(equalTo: intelligenceLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            socialNeedsLabel.topAnchor.constraint(equalTo: intelligenceLabel.bottomAnchor, constant: StyleGuide.Spaces.single),
            socialNeedsLabel.leadingAnchor.constraint(equalTo: breedNameLabel.leadingAnchor, constant: 0),
            
            socialNeedsDetailLabel.bottomAnchor.constraint(equalTo: socialNeedsLabel.bottomAnchor, constant: 0),
            socialNeedsDetailLabel.leadingAnchor.constraint(equalTo: socialNeedsLabel.trailingAnchor, constant: StyleGuide.Spaces.single / 2),
            
            breedDescriptionLabel.topAnchor.constraint(equalTo: catImageView.bottomAnchor, constant: StyleGuide.Spaces.single),
            breedDescriptionLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: StyleGuide.Spaces.double),
            breedDescriptionLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -StyleGuide.Spaces.double),
            breedDescriptionLabel.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -StyleGuide.Spaces.double)
        ]
        NSLayoutConstraint.activate(constrains)
    }
    
    private func configure() {
        catImageView.image = UIImage(named: breedViewModel.breedName)
        breedNameLabel.text = breedViewModel.breedName
        breedDescriptionLabel.text = breedViewModel.breedDescription
        originDetailLabel.text = breedViewModel.origin
        intelligenceDetailLabel.text = breedViewModel.intelligence
        socialNeedsDetailLabel.text = breedViewModel.socialNeeds
    }
}

// MARK: - Actions -
extension BreedShortInfoViewController {
    @objc func screenDidTap(sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
