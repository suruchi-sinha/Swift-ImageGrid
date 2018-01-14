//
//  CustomImageCell.swift
//  GetMyParking
//
//  Created by Suruchi Sinha on 1/14/18.
//  Copyright © 2018 Suruchi Sinha. All rights reserved.
//

import UIKit

class CustomImageCell: UICollectionViewCell {

    @IBOutlet private weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    public func setImageWithUrl(_ image: UIImage?) {
        imageView.image = image
    }

}
