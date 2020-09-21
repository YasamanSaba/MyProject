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
    typealias ComicDataSource = UICollectionViewDiffableDataSource<Int, ComicItem>
    var comicDataSource: ComicDataSource?
    typealias CharacterDataSource = UICollectionViewDiffableDataSource<Int, CharacterItem>
    var characterDataSource: CharacterDataSource!
    var comics: [Comic] = []
    var characters: [Character] = []
    var characterItems: [CharacterItem] = []
    var comicItems: [ComicItem] = []
    var selectedCharacterIndex: Int = 0 {
        didSet {
            downloadTasks.forEach{ $0.cancel() }
            try? comicService.fetchComics(characterId: Int(characters[selectedCharacterIndex].id), page: 0)
        }
    }
    var lastCharacterPage = 0
    var lastComicPage = 0
    var characterCollectionView: UICollectionView?
    var comicCollectionView: UICollectionView?
    var downloadTasks: [URLSessionDataTask] = []

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
    
    func select(character at: IndexPath) {
        self.selectedCharacterIndex = at.row
    }
}

extension ViewModel: CharacterServiceDelegateProtocol {
    func characters(fetchedCharacters: [Character]) {
        if lastCharacterPage == 0, let collectionView = characterCollectionView {
            self.characters = fetchedCharacters
            self.selectedCharacterIndex = 0
            self.characterDataSource = CharacterDataSource(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: CharacterItem) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseId, for: indexPath) as? CharacterCollectionViewCell else { return nil }
                cell.configure(item: item)
                if item.image == nil {
                    URLSession.shared.dataTask(with: item.url) { data, response, error in
                        DispatchQueue.main.async {
                            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200, error == nil else { return }
                            var updatedSnapshot = self.characterDataSource.snapshot()
                            item.image = UIImage(data: data)
                            updatedSnapshot.reloadItems([item])
                            self.characterDataSource.apply(updatedSnapshot, animatingDifferences: true)
                        }
                    }.resume()
                }
                return cell
            }
        } else {
            self.characters = self.characters + fetchedCharacters
        }
        self.characterItems = self.characters.map { CharacterItem(name: $0.name!,url: $0.img!, image: nil) }
        var snapshot = NSDiffableDataSourceSnapshot<Int, CharacterItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.characterItems, toSection: 0)
        self.characterDataSource.apply(snapshot)
    }
}

extension ViewModel: ComicServiceDelegateProtocol {
    func comics(fetchedComics: [Comic]) {
        if lastComicPage == 0, let collectionView = comicCollectionView {
            self.comics = fetchedComics
            self.comicDataSource = ComicDataSource(collectionView: collectionView) {
                (collectionView: UICollectionView, indexPath: IndexPath, item: ComicItem) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ComicCollectionViewCell.reuseId, for: indexPath) as? ComicCollectionViewCell else { return nil }
                cell.configuration(item: item)
                if item.img == nil {
                    let task = URLSession.shared.dataTask(with: item.url) { (data, response, error) in
                        DispatchQueue.main.async {
                            guard let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), error == nil, let comicDataSource = self.comicDataSource else { return }
                            var updateSnapshot = comicDataSource.snapshot()
                            item.img = UIImage(data: data)
                            updateSnapshot.reloadItems([item])
                            comicDataSource.apply(updateSnapshot, animatingDifferences: true)
                        }
                    }
                    self.downloadTasks.append(task)
                    task.resume()
                }
                return cell
            }
        } else {
            self.comics = self.comics + fetchedComics
        }
        self.comicItems = self.comics.map { ComicItem(url: $0.img!, img: nil, desc: $0.desc, title: $0.title)}
        var snapshot = NSDiffableDataSourceSnapshot<Int, ComicItem>()
        snapshot.appendSections([0])
        snapshot.appendItems(self.comicItems, toSection: 0)
        self.comicDataSource?.apply(snapshot)
    }
}

class CharacterItem: Hashable {
    
    static func == (lhs: CharacterItem, rhs: CharacterItem) -> Bool {
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

class ComicItem: Hashable {
    static func == (lhs: ComicItem, rhs: ComicItem) -> Bool {
        lhs === rhs
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
    
    var url: URL
    var img: UIImage?
    var desc: String?
    var title: String?
    
    init(url: URL, img: UIImage?, desc: String?, title: String?) {
        self.img = img
        self.desc = desc
        self.title = title
        self.url = url
    }
}
