//
//  PhotosViewController.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate  {
    
    @IBOutlet weak var collectionView : UICollectionView!
    

    var store: PhotoStore!
    var photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        let photo = photoDataSource.photos[indexPath.row]
        store.fetchImageForPhoto(photo, completion: { (ImageResult) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                //Get the most recent index path, as it may have changed.
                let photoIndex = find(self.photoDataSource.photos, photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                let visibleIndexPaths = self.collectionView.indexPathsForVisibleItems() as! [NSIndexPath]
                if (find(visibleIndexPaths, photoIndexPath) != nil) {
                    let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath) as! PhotoCollectionViewCell
                    cell.updateWithImage(photo.image)
                }
            })
        })
    }
}
