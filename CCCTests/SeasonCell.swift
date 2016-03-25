//
//  SeasonTableViewCell.swift
//  CCC
//
//  Created by Karl Söderberg on 2016-01-01.
//  Copyright © 2016 Lemon and Lime. All rights reserved.
//

import UIKit

class SeasonTableViewCell: UITableViewCell, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    var viewModel: MainViewModel!
    var provider: DataProvider!
    var section: Int!
    var onSelectedEpisode: ((Episode)->Void)!
    
    // DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if viewModel != nil {
            return 1
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(self.section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! EpisodeCell
        cell.episode = viewModel.dataForIndexPath(NSIndexPath(forRow: indexPath.item, inSection: section))
        cell.onSelectedEpisode = onSelectedEpisode
        return cell
    }
}
