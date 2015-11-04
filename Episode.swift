//
//  Episode.swift
//  CCC
//
//  Created by Karl Söderberg on 2015-11-01.
//  Copyright © 2015 Lemon and Lime. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Episode {
    
    enum Type{
        case None
        case Episode
        
        init(value: String){
            switch value{
                case "episode":
                self = Type.Episode
                
            default:
                self = Type.None
            }
        }
    }
    
    let mediaId: Int
    let type: Type
    let season: Int
    let launchDate: String?
    let pubDate: String?
    let pubDateTime: Int?
    let duration: String?
    let durationSeconds: String?
    let title: String?
    let description: String?
    let guests: Array<Guest>
    let images: Image?
    let mediaUrl: String?
    let urlSlug: String?
    let videoUrl:String?
    
    init(data: JSON){
        mediaId         = data["mediaId"].int!
        type            = Type(value: data["type"].string!)
        season          = Int(data["season"].string!)!
        launchDate      = data["launchDate"].string
        pubDate         = data["pubDate"].string
        pubDateTime     = data["pubDateTime"].int
        duration        = data["duration"].string
        durationSeconds = data["durationSeconds"].string
        title           = data["title"].string
        description     = data["description"].string
        
        guests =
            (data["guests"].array?.map({ (json: JSON) -> Guest in
                return Guest(name: json["name"].string ?? "")
            })) ?? []
        
        images          = Image(poster: data["images"]["poster"].string, thumb: data["images"]["thumb"].string)
        mediaUrl        = data["mediaUrl"].string
        urlSlug         = data["urlSlug"].string
        videoUrl        = data["videoUrl"].string
    }
}

struct Guest {
    let name:String
}

struct Image {
    let poster: String?
    let thumb: String?
}
