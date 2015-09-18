//
//  PhotoStore.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

enum ImageResult {
    case Success(UIImage)
    case Failure(NSError)
}

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
    
    func fetchImageForPhoto(photo: Photo, completion: ((ImageResult) -> Void)?) {
        let photoURL = photo.URL
        let request = NSURLRequest(URL: photoURL)
        let task = session.downloadTaskWithRequest(request, completionHandler: {
            (url, response, error) -> Void in
            
            var result: ImageResult
            // Get the URL to the local image data
            if let imageDataURL = url {
                // Get the data from this file
                var dataError: NSError?
                if let data = NSData(contentsOfURL: imageDataURL, options: nil, error: &dataError) {
                        // Attempt to create an image from the data
                        if let image = UIImage(data: data) {
                            photo.image = image
                            result = .Success(image)
                        }
                        else {
                            // Error creating the image from data
                            result = .Failure(createError("Couldn't load data into UIImage"))
                        }
                }
                else {
                    println("Error creating image: \(dataError!)")
                    // Error with the data
                    result = .Failure(createError("Unexpected NSData contents"))
                } }
            else {
                // Error with the web service request
                result = .Failure(error)
            }
            completion?(result)
        })
        task.resume()
    }
}