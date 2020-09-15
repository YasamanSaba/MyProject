//
//  ComicCollectionViewCell.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/14/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ComicCollectionViewCell: UICollectionViewCell {
    static let reuseId = String(describing: ComicCollectionViewCell.self)
    var img: UIImageView!
    var desc: UILabel!
    var title: UILabel!
    
    func configuration(image: UIImage, des: String, header: String) {
        img = UIImageView()
        img.image = image
        desc = UILabel()
        desc.text = des
        desc.numberOfLines = 0
        desc.font = UIFont.preferredFont(forTextStyle: .caption1)
        title = UILabel()
        title.text = header
        title.font = UIFont.preferredFont(forTextStyle: .callout)
        contentView.addSubview(img)
        contentView.addSubview(title)
        contentView.addSubview(desc)
        img.translatesAutoresizingMaskIntoConstraints = false
        desc.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            img.widthAnchor.constraint(equalTo: img.heightAnchor),
            img.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            img.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            img.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            title.topAnchor.constraint(equalTo: img.topAnchor),
            title.leadingAnchor.constraint(equalTo: img.trailingAnchor, constant: 5),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            desc.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 2),
            desc.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            desc.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            desc.bottomAnchor.constraint(equalTo: img.bottomAnchor)
        ])
    }
}
