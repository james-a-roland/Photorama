//
//  PhotoDataSource.swift
//  Photorama
//
//  Created by James Roland on 9/18/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import Foundation
import UIKit

class PhotoDataSource: NSObject, UICollectionViewDataSource
{
    let photos: [Photo]
    
    init(photos: [Photo] = [Photo]()) {
        self.photos = photos
        super.init()
    }
    
    //MARK: UICollectionViewDataSource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let identifier = "UICollectionViewCell"
        
        let cell =
        collectionView.dequeueReusableCellWithReuseIdentifier(identifier,
            forIndexPath: indexPath) as! PhotoCollectionViewCell
        let photo = photos[indexPath.row]
        cell.updateWithImage(photo.image)
        
        return cell
    }
    
    
}
