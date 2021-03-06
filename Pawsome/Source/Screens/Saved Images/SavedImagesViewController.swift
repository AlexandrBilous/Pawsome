//
//  SavedImagesViewController.swift
//  Pawsome
//
//  Created by Marentilo on 08.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SavedImagesViewController : UICollectionViewController {
    private var savedImagesModel : SavedImagesViewModel
    private let imageView = UIImageView()
    
    private var selectedImageSource : ImagesList = .liked {
        didSet {
            updateView()
        }
    }
    
    private lazy var segmentedController : SegmentedController = {
        let view = SegmentedController(titles: [Strings.liked, Strings.saved], selectedSection: 0) { [weak self] (value) in
            if let newImageSource = ImagesList(rawValue: value) {
                self?.selectedImageSource = newImageSource
            }
        }
        return view
    } ()
    
    init(savedImagesModel : SavedImagesViewModel = SavedImagesViewModelImplementation()) {
        self.savedImagesModel = savedImagesModel
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(collectionViewLayout: layout)
        navigationItem.title = Strings.personalImages
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateView()
    }
    
    private func updateView() {
        imageView.image = savedImagesModel.imageForEmptySource(selectedImageSource)
        self.collectionView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        setStandartBackButton()
        collectionView.delegate = self
        collectionView.registerReusableCell(SingleViewFeedCell.self)
        collectionView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        savedImagesModel.urlsArrayDidUpdate = { [weak self] _ in
            self?.collectionView.reloadData()
        }
        [segmentedController, imageView].forEach { view.addSubview($0) }
        setupConstraints()
    }
    
    private func setupConstraints() {
        [segmentedController, collectionView, imageView].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        NSLayoutConstraint.activate([
            segmentedController.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            segmentedController.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            segmentedController.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collectionView.topAnchor.constraint(equalTo: segmentedController.bottomAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource -
extension SavedImagesViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedImageSource == .liked ? savedImagesModel.likedImagesCount : savedImagesModel.savedImagesCount
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(SingleViewFeedCell.self, for: indexPath) else { fatalError() }
        savedImagesModel.savedImageForItem(at: indexPath.row, for: selectedImageSource) { (image) in
            cell.configure(with: image)
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout -
extension SavedImagesViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.bounds.width - 6) / 3
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        savedImagesModel.presentFullScreenImage(at: indexPath.row, for: selectedImageSource)
    }
}
