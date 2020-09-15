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
    typealias CharacterDataSource = UICollectionViewDiffableDataSource<Int, Character>
    var characterDataSource: CharacterDataSource!
    var comicArr: [Comic] = []
    var characterArr: [Character] = []
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
                (collectionView: UICollectionView, indexPath: IndexPath, character: Character) -> UICollectionViewCell? in
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCollectionViewCell.reuseId, for: indexPath) as? CharacterCollectionViewCell else { return nil }
                let https = "https" + character.img!.path.dropFirst(5)
                let task = URLSession.shared.dataTask(with: URL(string: https)!) { data, response, error in
                    guard let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), let data = data, let image = UIImage(data: data) else { return }
                    DispatchQueue.main.async {
                        cell.configure(image: image, name: character.name!)
                    }
                }
                task.resume()
                return cell
            }
        } else {
            self.characterArr = self.characterArr + fetchedCharacters
        }
        
            var snapshot = NSDiffableDataSourceSnapshot<Int, Character>()
            snapshot.appendSections([0])
            snapshot.appendItems(self.characterArr, toSection: 0)
            self.characterDataSource.apply(snapshot)
        
        
    }
}

extension ViewModel: ComicServiceDelegateProtocol {
    func comics(fetchedComics: [Comic]) {
        
    }
}
