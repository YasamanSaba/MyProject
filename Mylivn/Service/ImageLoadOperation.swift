//
//  ImageLoadOperation.swift
//  Mylivn
//
//  Created by Yasaman Farahani Saba on 9/20/20.
//  Copyright © 2020 Dream Catcher. All rights reserved.
//

import UIKit

class ImageLoadOperation: Operation {
    
    let url: URL
    let comicItem: ComicItem
    let comicDataSource: UICollectionViewDiffableDataSource<Int,ComicItem>?
    
    init(url: URL, comicItem: ComicItem, comicDataSource: UICollectionViewDiffableDataSource<Int,ComicItem>?) {
        self.url = url
        self.comicItem = comicItem
        self.comicDataSource = comicDataSource
    }
    
    override func main() {
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                guard let self = self, let data = data, let response = response as? HTTPURLResponse, (200..<300).contains(response.statusCode), error == nil, let comicDataSource = self.comicDataSource else { return }
                var updateSnapshot = comicDataSource.snapshot()
                self.comicItem.img = UIImage(data: data)
                updateSnapshot.reloadItems([self.comicItem])
                comicDataSource.apply(updateSnapshot, animatingDifferences: true)
            }
        }
        task.resume()
    }
}
