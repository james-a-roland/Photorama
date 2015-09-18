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
    
    func fetchRecentPhotos(#completion: ((PhotosResult) -> Void)?) {
        if let url = FlickerAPI.recentPhotosURL() {
            let request = NSURLRequest(URL: url)
            let task = session.dataTaskWithRequest(request, completionHandler: {
                (data, response, error) -> Void in
                
                var result:PhotosResult
                if let jsonData = data {
                    result = FlickerAPI.photosFromJSONData(jsonData)
                }
                else if let requestError = error {
                    println("Error fetching recent photos: \(requestError)")
                    result = .Failure(requestError)
                }
                else {
                    result = .Failure(createError("Unexpected request response"))
                }
                completion?(result)
            })
            task.resume()
        }
        else {
            completion?(.Failure(createError("Error generating URL")))
        }
    }
}