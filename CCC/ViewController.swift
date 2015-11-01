//
//  ViewController.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-10-30.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    var mediaPlayer: MPMoviePlayerController = MPMoviePlayerController(contentURL: NSURL(string: "http://content-ause1.uplynk.com/bde2566cc46d4a3ba40a5f5da0986d1b/g.m3u8?ad=crackle_live&pbs=a40f9d3d563243c1a61f54bcf687c036"))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.mediaPlayer.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mediaPlayer.view)
        self.view.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat("H:|[player]|", options: NSLayoutFormatOptions.AlignmentMask, metrics: nil, views: ["player" : mediaPlayer.view])
            )
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[player]|", options: NSLayoutFormatOptions.AlignmentMask, metrics: nil, views: ["player" : mediaPlayer.view]))
        
        mediaPlayer.play()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

