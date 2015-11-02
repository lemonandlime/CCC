//
//  MainTableViewController.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-02.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

class MainTableViewController: UITableViewController {
    let imageDonwloader = ImageDownloader.init()
    var episodes: [Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
            }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getData()
    }

    func getData(){
        DataProvider.sharedInstance.getMainData { (result) -> Void in
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
                
            case .Success(let episodes):
                self.episodes = episodes
                self.tableView.reloadData()
            }
        }
    }

    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let episode = episodes[indexPath.row]
        cell.textLabel?.text = episode.title

        return cell
    }
}
