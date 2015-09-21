//
//  PhotosViewController.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
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
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell,
        forItemAtIndexPath indexPath: NSIndexPath) {
            let photo = photoDataSource.photos[indexPath.row]
            // Download the image data, which could take some time
            store.fetchImageForPhoto(photo, completion: {
                (result) -> Void in
                
                NSOperationQueue.mainQueue().addOperationWithBlock() {
                    // The index path for the photo might have changed between the
                    // time the request started and finished, so find the most
                    // recent index path
                    // (Note: You will have an error on the next line; you will fix it shortly)
                    let photoIndex = find(self.photoDataSource.photos, photo)!
                    let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                    // When the request finishes, only update the cell if it's still visible
                    let visibleIndexPaths =
                    self.collectionView.indexPathsForVisibleItems() as! [NSIndexPath]
                    if find(visibleIndexPaths, photoIndexPath) != nil {
                        let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath)
                            as! PhotoCollectionViewCell
                        cell.updateWithImage(photo.image)
                    }
                }
            })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPhoto" {
            if let selectedIndexPath =
                collectionView.indexPathsForSelectedItems().first as? NSIndexPath {
                    let photo = photoDataSource.photos[selectedIndexPath.row]
                    let destinationVC =
                    segue.destinationViewController as! PhotoInfoViewController
                    destinationVC.photo = photo
                    destinationVC.store = store
            }
        } 
    }

    
}
