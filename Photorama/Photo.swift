//
//  Photo.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import Foundation

class Photo {
    let title: String
    let URL: NSURL
    let photoID: String
    let dateTaken: NSDate
    
    init(title: String, photoID: String, URL: NSURL, dateTaken: NSDate) {
        self.title = title
        self.photoID = photoID
        self.URL = URL
        self.dateTaken = dateTaken
    }
}
