//
//  ComicViewModel.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/15/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ViewModel {
    var comicService: ComicServiceType
    var characterService: CharacterServiceType
    typealias ComicDataSource = UICollectionViewDiffableDataSource<Int, Comic>
    var comicDataSource: ComicDataSource!
    typealias CharacterDataSource = UICollectionViewDiffableDataSource<Int, Item>
    var characterDataSource: CharacterDataSource!
    var comicArr: [Comic] = []
    var characterArr: [Character] = []
    var items: [Item] = []
    var selectedCharacterIndex: Int = 0 {
        didSet {
            
        }
    }
    var lastCharacterPage = 0
    var characterCollectionView: UICollectionView?
    var comicCollectionView: UICollectionView?

    init(comicService: ComicServiceType, characterService: CharacterServiceType) {
        self.comicService = comicService
        self.characterService = characterService
        self.comicService.delegate = self
        self.characterService.delegate = self
    }
    
    func start(characterCollectionView: UICollectionView, comicCollectionView: UICollectionView) {
        self.characterCollectionView = characterCollectionView
        self.comicCollectionView = comicCollectionView
        try? characterService.fetchCharacters(for: 0)
    }
    
    func makeDataSource(for collectionView: UICollectionView) {
        comicDataSource = ComicDataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, comic: Comic) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.reuseId, for: indexPath) as? ComicCollectionViewCell else { return nil }
            //cell.img =
            return cell
        }
    }
}

extension ViewModel: CharacterServiceDelegateProtocol {
    func characters(fetchedCharacters: [Character]) {
        if lastCharacterPage == 0, let collectionView = characterCollectionView {
            self.characterArr = fetchedCharacters
            self.characterDataSource = CharacterDataSource(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseId, for: indexPath) as? CharacterCollectionViewCell else { return nil }
                cell.configure(item: item)
                if item.image == nil {
                    URLSession(configuration: .default).dataTask(with: item.url) { data, response, error in
                        DispatchQueue.main.async {
                            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
                            var updatedSnapshot = self.characterDataSource.snapshot()
                            if let datasourceIndex = updatedSnapshot.indexOfItem(item) {
                                let item = self.items[datasourceIndex]
                                item.image = UIImage(data: data)
                                updatedSnapshot.reloadItems([item])
                                self.characterDataSource.apply(updatedSnapshot, animatingDifferences: true)
                            }
                        }
                    }.resume()
                }
                return cell
            }
        } else {
            self.characterArr = self.characterArr + fetchedCharacters
        }
        self.items = self.characterArr.map { Item(name: $0.name!,url: $0.img!, image: nil) }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Item>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.items, toSection: 0)
        self.characterDataSource.apply(snapshot)
    }
}

extension ViewModel: ComicServiceDelegateProtocol {
    func comics(fetchedComics: [Comic]) {
        
    }
}

class Item: Hashable {
    
    static func == (lhs: Item, rhs: Item) -> Bool {
        lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
    
    var name: String
    var url: URL
    var image: UIImage?
    
    init(name: String,url: URL, image: UIImage?) {
        self.name = name
        self.url = url
        self.image = image
    }
}
