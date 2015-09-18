//
//  PhotosViewController.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var collectionView : UICollectionView!
    

    var store: PhotoStore!
    var photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            NSOperationQueue.mainQueue().addOperationWithBlock {
                switch photosResult {
                case let .Success(photos):
                    println("Successfully found \(photos.count) photos")
                    self.photoDataSource = PhotoDataSource(photos: photos)
                case let .Failure(error):
                    println("Error fetching recent photos: \(error)")
                    self.photoDataSource = PhotoDataSource()
                }
                self.collectionView.dataSource = self.photoDataSource
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
}
