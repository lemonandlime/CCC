//
//  EpisodeModelTest.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-01.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import XCTest
import SwiftyJSON

class EpisodeModelTest: XCTestCase {
    
    var json: JSON?
    
    override func setUp() {
        super.setUp()
        let path = NSBundle(forClass: self.dynamicType).pathForResource("mainJSONCCC", ofType: "json")
        let data = NSData(contentsOfFile: path!)
        json = JSON(data: data!)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEpisode() {
        json!.array?.forEach({ (jsonObject: JSON) -> () in
            let episode = Episode(data: jsonObject)
            
            //Check if episode whas created
            XCTAssertNotNil(episode)
            
            //Check for correct type
            switch episode.type{
            case .Episode:
                XCTAssertTrue(jsonObject["type"] == "episode")
            case .None:
                XCTAssertFalse(jsonObject["type"] == "episode")
            }
            
            
        })
        
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
