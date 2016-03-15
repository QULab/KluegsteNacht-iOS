//
//  ExhibitionCell.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 22/03/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class ExhibitionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var mapButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    override func awakeFromNib() {
        mapButton.imageView!.tintColor = UIColor.lightGrayColor()
        favoriteButton.imageView!.tintColor = UIColor.lightGrayColor()
        shareButton.imageView!.tintColor = UIColor.lightGrayColor()
    }
}