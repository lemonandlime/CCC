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

class MainViewController: UIViewController, UICollectionViewDataSource {

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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! EpisodeCell
        let episode = viewModel.dataForIndexPath(indexPath)
        
        cell.titleLabel.text = episode.title
        
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
}

