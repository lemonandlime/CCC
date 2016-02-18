//
//  DataProviderTest.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-01.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//
import XCTest
import Alamofire
import AlamofireImage
@testable import CCCTV

class DataProviderTest: XCTestCase {
    
    let provider = DataProvider.sharedInstance
    
    func testGetMainData() {
        
        let expectation = expectationWithDescription("...")
        
        provider.getMainData { (result) -> Void in
            switch result {
            case .Failure(let error):
                XCTAssertFalse(true, "Data retrival failed with error" + error.localizedDescription)
                
            case .Success(let episodes, _):
                XCTAssertGreaterThan(episodes.count, 0)
            }
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(10) { (error) -> Void in
            
            if let error = error {
                print("error: " + error.localizedDescription)
            }
        }
    }
    
}
