//
//  ViewController.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-10-30.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit
import MediaPlayer

class PlayerViewController: UIViewController {
    var episode: Episode!
    var mediaPlayer: MPMoviePlayerController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = episode.title
        mediaPlayer = MPMoviePlayerController(contentURL: NSURL(string: episode!.mediaUrl!))
        mediaPlayer!.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mediaPlayer!.view)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[player]|", options: NSLayoutFormatOptions.AlignmentMask, metrics: nil, views: ["player" : mediaPlayer!.view])
            )
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[player]|", options: NSLayoutFormatOptions.AlignmentMask, metrics: nil, views: ["player" : mediaPlayer!.view]))
        
        mediaPlayer!.play()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        mediaPlayer!.stop()
    }
}

