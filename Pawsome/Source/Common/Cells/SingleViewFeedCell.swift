//
//  SingleViewFeedCell.swift
//  Pawsome
//
//  Created by Marentilo on 02.05.2020.
//  Copyright © 2020 Marentilo. All rights reserved.
//

import UIKit

final class SingleViewFeedCell : UICollectionViewCell {
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func setupView() {
        contentView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive                 = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive         = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive       = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive           = true
    }
    
    func configure(with image : UIImage? = #imageLiteral(resourceName: "s1200")) {
        imageView.image = image
    }
}
