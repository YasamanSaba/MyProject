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
    
    func configure(image: URL, name: String) {
        img = UIImageView()
        img.layer.masksToBounds = true
        img.layer.cornerRadius = 5
        URLSession.shared.dataTask(with: image) { [weak self] data, response, error in
            guard let self = self, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data, let fetchedImage = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.img.image = fetchedImage
            }
        }.resume()
        lblName = UILabel()
        lblName.text = name
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
