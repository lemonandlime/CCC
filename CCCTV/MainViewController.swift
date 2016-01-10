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

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let provider = DataProvider.sharedInstance
    var player: AVPlayer!
    let viewModel = MainViewModel()
    @IBOutlet var tableView: UITableView!
    
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
                self.tableView.reloadData()
            }
        }
    }

    
    // DataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! SeasonTableViewCell
        cell.section = indexPath.section
        cell.viewModel = viewModel
        cell.provider = provider
        cell.collectionView.reloadData()
        cell.onSelectedEpisode = {(episode) in self.playEpisode(episode)}

        return cell
    }
    
    func tableView(tableView: UITableView, canFocusRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
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

