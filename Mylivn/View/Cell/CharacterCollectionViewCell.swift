//
//  CharacterCollectionViewCell.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/14/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class CharacterCollectionViewCell: UICollectionViewCell {
    static let reuseId = String(describing: CharacterCollectionViewCell.self)
    private var img: UIImageView!
    private var lblName: UILabel!
    
    func configure(item: CharacterItem) {
        img = UIImageView()
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 5
        img.layer.borderColor = UIColor.systemGray3.cgColor
        img.layer.borderWidth = 1
        img.image = item.image
        lblName = UILabel()
        lblName.text = item.name
        lblName.font = UIFont.preferredFont(forTextStyle: .callout)
        lblName.adjustsFontSizeToFitWidth = true
        lblName.minimumScaleFactor = 0.5
        contentView.addSubview(img)
        contentView.addSubview(lblName)
        img.translatesAutoresizingMaskIntoConstraints = false
        lblName.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            img.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            img.heightAnchor.constraint(equalTo: img.widthAnchor),
            lblName.topAnchor.constraint(equalTo: img.bottomAnchor, constant: 2),
            lblName.leadingAnchor.constraint(equalTo: img.leadingAnchor),
            lblName.trailingAnchor.constraint(equalTo: img.trailingAnchor),
            lblName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img?.image = nil
        lblName?.text = nil
    }
}
