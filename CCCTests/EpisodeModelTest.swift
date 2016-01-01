//
//  EpisodeModelTest.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-01.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import XCTest
import SwiftyJSON
import Alamofire
import AlamofireImage

class EpisodeModelTest: XCTestCase {
    
    var json: JSON = nil
    var episodes: [Episode] = []
    
    override func setUp() {
        super.setUp()
        let path = NSBundle(forClass: self.dynamicType).pathForResource("mainJSONCCC", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        json = JSON(data: data!)
        episodes = (json.array?.map({ (jsonObject: JSON) -> Episode in
            return Episode(data: jsonObject)
        }))!
    }
    
   
    
    func testType() {
        for (index, episode) in episodes.enumerate(){
            switch episode.type{
            case .Episode:
                XCTAssertTrue(json[index]["type"] == "episode")
            case .None:
                XCTAssertFalse(json[index]["type"] == "episode")
            }
        }
    }
    
    func testGuests() {
        for (index, episode) in episodes.enumerate(){
            XCTAssertEqual(episode.guests.count, json[index]["guests"].arrayObject?.count)
        }
    }
    
    func testImages() {
        for (index, episode) in episodes.enumerate(){
            XCTAssertEqual(episode.images?.poster, json[index]["images"]["poster"].string)
            XCTAssertEqual(episode.images?.thumb, json[index]["images"]["thumb"].string)
        }
    }
    
}
