//
//  FlickerAPI.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import Foundation

enum Method: String {
    case RecentPhotos = "flickr.photos.getRecent"
}

enum PhotosResult {
    case Success([Photo])
    case Failure(NSError)
}

private let baseURLString = "https://api.flickr.com/services/rest"
private let APIKey = "a6d819499131071f158fd740860a5a88"

class FlickerAPI {
    
    private class func flickrUrl(#method: Method, parameters: [String:String]?) -> NSURL? {
        if let components = NSURLComponents(string: baseURLString) {
            var queryItems = [NSURLQueryItem]()
            var baseParams = [
                "method": method.rawValue,
                "format": "json",
                "nojsoncallback": "1",
                "api_key": APIKey
            ]
            
            for (key, value) in baseParams {
                let item = NSURLQueryItem(name: key, value: value)
                queryItems.append(item)
            }
            
            if let additionalParams = parameters {
                for (key, value) in additionalParams {
                    let item = NSURLQueryItem(name: key, value: value)
                    queryItems.append(item)
                }
            }
            components.queryItems = queryItems
            return components.URL
        }
        
        return nil
    }
    
    
    class func recentPhotosURL() -> NSURL? {
        return flickrUrl(method: .RecentPhotos, parameters: ["extras": "url_h,date_taken"])
    }
    
    class func photosFromJSONData(data: NSData) -> PhotosResult {
        var jsonParsingError: NSError?
        if let jsonObject: AnyObject = NSJSONSerialization.JSONObjectWithData(data,
            options: nil,
            error: &jsonParsingError) {
                
                if let photos = jsonObject["photos"] as? [String : AnyObject] {
                    if let photosArray = photos["photo"] as? [[String : AnyObject]] {
                        for photoJSON in photosArray {
                            println("Photo: \(photoJSON)")
                        }
                    }
                }
                
                // For now, just return an empty array
                return .Success([Photo]())
        }
        else {
            println("Error parsing JSON: \(jsonParsingError!)")
            return .Failure(jsonParsingError!)
        }
    }
    
    
}