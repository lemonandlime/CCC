//
//  MainTableViewController.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-02.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import AlamofireImage
import Alamofire

class MainTableViewController: UITableViewController {
    let provider = DataProvider.sharedInstance
    var player: AVPlayer!
    var seasons: [Int:[Episode]] = [:]
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if seasons.isEmpty {
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
                self.seasons = seasons
                self.tableView.reloadData()
            }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return seasons.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (seasons[section+1]?.count)!
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(format: "Season %d", seasons[section+1]![0].season);
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let episode = seasons[indexPath.section+1]![indexPath.row]
        cell.textLabel?.text = episode.title
        
        cell.imageView?.image = nil
        
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let episode = seasons[indexPath.section+1]![indexPath.row]
        self.playEpisode(episode)
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
