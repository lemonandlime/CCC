//
//  ViewController.swift
//  CCCTV
//
//  Created by Karl Söderberg on 2015-11-03.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AlamofireImage
import Alamofire

class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    let provider = DataProvider.sharedInstance
    var player: AVPlayer!
    let viewModel = MainViewModel()

    @IBOutlet var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if viewModel.numberOfSections() == 0 {
            self.getData()
        }
    }
    
    func getData(){
        provider.getMainData { (result) -> Void in
            switch result{
            case .Failure(let error):
                let alert = UIAlertController(
                    title: "Error",
                    message: error.localizedDescription,
                    preferredStyle: .Alert)
                alert.addAction(UIAlertAction(
                    title: "OK",
                    style: .Default,
                    handler: nil))
                self.presentViewController(alert, animated: true, completion: { self.getData()
                    
                })
                
            case .Success(let seasons):
                self.viewModel.dataSource = seasons
                self.collectionView.reloadData()
            }
        }
    }

    
    // DataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()

    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "SectionHeader", forIndexPath: indexPath) as! SectionHeaderView;
            headerView.titleLabel.text = self.viewModel.titleForSection(indexPath.section);
            return headerView;
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! EpisodeCell
        let episode = viewModel.dataForIndexPath(indexPath)
        cell.imageView.adjustsImageWhenAncestorFocused = true
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
        self.playEpisode(viewModel.dataForIndexPath(indexPath))
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

    
    private func playEpisode(episode: Episode) {
        let player = AVPlayer(URL: NSURL(string: episode.mediaUrl!)!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.presentViewController(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }
}

