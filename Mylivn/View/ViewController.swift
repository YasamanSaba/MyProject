//
//  ViewController.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/8/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Properties
    var characterCollectionView: UICollectionView!
    var comicCollectionView: UICollectionView!
    var viewModel: ViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ViewModel(comicService: ComicService(authentication: Authentication()), characterService: CharacterService(authentication: Authentication()))
        setup()
        
    }
    
    func setup() {
        self.characterCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: configureCharacterLayout())
        self.comicCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: configureComicLayout())
        comicCollectionView.dataSource = self
        characterCollectionView.register(CharacterCollectionViewCell.self, forCellWithReuseIdentifier: CharacterCollectionViewCell.reuseId)
        comicCollectionView.register(ComicCollectionViewCell.self, forCellWithReuseIdentifier: ComicCollectionViewCell.reuseId)
        characterCollectionView.translatesAutoresizingMaskIntoConstraints = false
        comicCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(characterCollectionView)
        self.view.addSubview(comicCollectionView)
        characterCollectionView.backgroundColor = .white
        comicCollectionView.backgroundColor = .white
        NSLayoutConstraint.activate([
            characterCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            characterCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            characterCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            characterCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 1/6),
            comicCollectionView.topAnchor.constraint(equalTo: characterCollectionView.bottomAnchor, constant: 5),
            comicCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 5),
            comicCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -5),
            comicCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 5/6)
        ])
        viewModel.start(characterCollectionView: characterCollectionView, comicCollectionView: comicCollectionView)
    }
    
    func configureCharacterLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(self.view.frame.height / 7 - 6), heightDimension: .fractionalHeight(1.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func configureComicLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [])
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize( widthDimension: .fractionalWidth(1.0),
        heightDimension: .fractionalWidth(1/3) )
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.reuseId, for: indexPath) as? ComicCollectionViewCell else { fatalError() }
        let img = UIImage(named: "image_not_available")!
        cell.configuration(image: img, des: "The fates of The Initiative, the United States, and Planet Earth hang in the balance. Plus: Former Avenger, Delroy Garret, assumes the mantle and arsenal of Earth's greatest Skrull-Hunter, The 3-D Man.", header: "Avengers: The Initiative (2007) #14")
        return cell
    }
    
    
}
