//
//  EpisodeCell.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-04.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit

class EpisodeCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var guestsLabel: UILabel!
    var onSelectedEpisode: ((Episode)->Void)!
    
    override var selected: Bool {
        didSet {
            if let episode = episode where selected != oldValue && selected{
                onSelectedEpisode(episode)
            }
        }
    }
    
    var episode: Episode? {
        didSet {
            if let episode = episode {
                titleLabel.text = episode.title
                guestsLabel.text = episode.guestsString;
                
                DataProvider.sharedInstance.getImageForEpisode(episode, size: .Thumbnail) { (result) -> Void in
                    switch result {
                    case .Failure(let error):
                        print(error)
                        
                    case .Success(let image):
                        self.imageView?.image = image
                    }
                }
            }
        }
    }
    
    override func didUpdateFocusInContext(context: UIFocusUpdateContext, withAnimationCoordinator coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({ () -> Void in
            switch self.focused {
            case true:
                self.titleLabel.alpha = 1.0
                self.guestsLabel.transform = CGAffineTransformMakeTranslation(0, 30)
            case false:
                self.titleLabel.alpha = 0.0
                self.guestsLabel.transform = CGAffineTransformIdentity
            }
            
            },
            completion: nil)
    }
}
