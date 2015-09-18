//
//  PhotoCollectionViewCell.swift
//  Photorama
//
//  Created by James Roland on 9/18/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell{
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func updateWithImage(image:UIImage?) {
        if let imageToDisplay = image {
            spinner.stopAnimating()
            imageView.image = imageToDisplay
        }
        else {
            spinner.startAnimating()
            imageView = nil
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateWithImage(nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateWithImage(nil)
    }
}
