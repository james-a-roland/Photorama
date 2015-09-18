//
//  PhotoStore.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import Foundation

class PhotoStore {
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchRecentPhotos() {
        if let url = FlickerAPI.recentPhotosURL() {
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> Void in
                if let jsonData = data {
                    if let jsonString = NSString(data: jsonData,
                        encoding: NSUTF8StringEncoding) {
                            println("\(jsonString)")
                    } }
                else if let requestError = error {
                    println("Error fetching recent photos: \(requestError)")
                }
                else {
                    println("Unexpected error with the request")
                }
            })
            task.resume()
        }
    }
}