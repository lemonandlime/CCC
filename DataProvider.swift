//
//  DataProvider.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-01.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire



private let _sharedInstance = DataProvider()
private let baseUrl = "http://46.101.78.53:3000/"
class DataProvider: NSObject {
    
    
    class var sharedInstance : DataProvider {
        return _sharedInstance
    }
    
    func getMainData(onCompletion: Result<[Episode], NSError> -> Void) {
        Alamofire.request(
            .GET,
            baseUrl,
            parameters: nil,
            encoding: .URL,
            headers: nil)
            .responseData { (response: Response) -> Void in
                switch response.result{
                case .Failure(let error):
                    onCompletion(Result.Failure(error))
                
                case .Success(let data):
                    let episodes: [Episode] = (JSON(data: data)
                        .array?
                        .map({ (json: JSON) -> Episode in
                            return Episode(data: json)
                        })) ?? []
                    onCompletion(Result.Success(episodes))
                }
        }
    }
}

