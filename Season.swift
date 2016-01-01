//
//  Season.swift
//  CCC
//
//  Created by Karl Söderberg on 2016-01-01.
//  Copyright © 2016 Lemon and Lime. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Season {
    let episodes: [Episode]
    let name: String
    let number: Int
    
    init(episodes: [Episode]){
        assert(!episodes.isEmpty, "A Season may never be initialized with an empty array")

        self.episodes = episodes
        number = episodes.first!.season
        self.name = "Season " + String(number)
    }
}