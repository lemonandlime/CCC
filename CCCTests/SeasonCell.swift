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
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(self.section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! EpisodeCell
        let episode = viewModel.dataForIndexPath(NSIndexPath(forRow: indexPath.item, inSection: section))
        cell.titleLabel.text = episode.title;
        cell.guestsLabel.text = "with " + episode.guestsString;
        
        provider.getImageForEpisode(episode, size: .Thumbnail) { (result) -> Void in
            switch result {
            case .Failure(let error):
                print(error)
                
            case .Success(let image):
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        onSelectedEpisode(viewModel.dataForIndexPath(NSIndexPath(forItem: indexPath.item, inSection: section)))
    }
    
    func collectionView(collectionView: UICollectionView, didUpdateFocusInContext context: UICollectionViewFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocusInContext(context, withAnimationCoordinator: coordinator)
        
        if let indexPath = context.previouslyFocusedIndexPath {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EpisodeCell
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.focusCell(cell, focus: false)
                }, completion: nil)
            
        }
        
        context.previouslyFocusedIndexPath
        
        if let indexPath = context.nextFocusedIndexPath {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! EpisodeCell
            coordinator.addCoordinatedAnimations({ () -> Void in
                self.focusCell(cell, focus: true)
                }, completion: nil)
        }
    }
    
    private func focusCell(cell: EpisodeCell, focus: Bool) {
        switch focus {
        case true:
            cell.titleLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2, 1.2), CGAffineTransformMakeTranslation(0, 30))
            cell.guestsLabel.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.2, 1.2), CGAffineTransformMakeTranslation(0, 30))
        case false:
            cell.titleLabel.transform = CGAffineTransformIdentity
            cell.guestsLabel.transform = CGAffineTransformIdentity
        }
    }


}
