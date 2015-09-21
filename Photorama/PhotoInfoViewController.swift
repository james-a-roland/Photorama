//
//  PhotoInfoViewController.swift
//  Photorama
//
//  Created by James Roland on 9/21/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class PhotoInfoViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            navigationItem.title = photo.title
        }
    }
    var store: PhotoStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.fetchImageForPhoto(photo, completion: { (result) -> Void in
            switch result {
            case let .Success(image):
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    self.imageView.image = image
                })
            case let .Failure(error):
                println("Error fetching image for the photo: \(error)")
            }
        })
    }
}
