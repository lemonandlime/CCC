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
import AlamofireImage



private let _sharedInstance = DataProvider()
private let baseUrl = "http://46.101.78.53:3000/"
private let cache = NSCache()
private let imageDownloader = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .FIFO,
    maximumActiveDownloads: 4,
    imageCache: AutoPurgingImageCache()
)

private let kMainDataKey = "mainData"


class DataProvider: NSObject {
    
    class var sharedInstance : DataProvider {
        return _sharedInstance
    }
    
    func getMainData(onCompletion: Result<[Int:[Episode]], NSError> -> Void) {
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
                    onCompletion(Result.Success(self.sortBySeason(episodes)))
                }
        }
    }
    
    func getImageForEpisode(episode: Episode, size: ImageSize, onCompletion: Result<UIImage, NSError> -> Void) {
        guard let imageUrl = episode.images?.thumb else {
            let error = NSError(
                domain: "CCCErrorDomain",
                code: -10,
                userInfo: [NSLocalizedDescriptionKey: "Missing url"])
            onCompletion(Result.Failure(error))
            return
        }
        
        let URLRequest = NSURLRequest(URL: NSURL(string: imageUrl)!)
        
        imageDownloader.downloadImage(URLRequest: URLRequest) { (response) -> Void in
            switch response.result {
            case .Failure(let error):
                onCompletion(Result.Failure(error))
                
            case .Success(let image):
                onCompletion(Result.Success(image))
            }
        }
    }
    
    private func sortBySeason(episodes: [Episode]) -> [Int : [Episode]] {
        var seasons = [Int : [Episode]]();
        
        let episodesList = episodes.filter { (episode) -> Bool in
            switch episode.type {
            case .Episode:
                return true
            case .None:
                return false
            }
        }
        
        episodesList.forEach { (episode) -> () in
            
            if seasons[episode.season] == nil {
                seasons[episode.season] = Array();
            }
            
            seasons[episode.season]?.append(episode);
        }
        
        return seasons;
    }
    
    enum ImageSize {
        case Thumbnail
        case Regular
    }
}

