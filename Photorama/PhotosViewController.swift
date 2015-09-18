//
//  PhotosViewController.swift
//  Photorama
//
//  Created by James Roland on 9/17/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            switch photosResult {
            case let .Success(photos):
                println("Successfully found \(photos.count) recent photos")
                if let firstPhoto = photos.first {
                    self.store.fetchImageForPhoto(firstPhoto, completion: { (imageResult) -> Void in
                        switch imageResult {
                        case let .Success(image):
                            NSOperationQueue.mainQueue().addOperationWithBlock {
                                self.imageView.image = image
                            }
                            self.imageView.image = image
                        case let .Failure(error):
                            println("Error downloading image: \(error)")
                        }
                    })
                }
            case let .Failure(error):
                println("Error fetching recent photos: \(error)")
            }
        }
    }
    
}
