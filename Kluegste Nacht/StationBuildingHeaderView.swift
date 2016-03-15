//
//  StationBuildingHeaderView.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 22/03/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class StationBuildingHeaderView: UICollectionReusableView {
    @IBOutlet weak var stationBuildingLabel: UILabel!
    @IBOutlet weak var stationBuildingImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stationBuildingImage.image = stationBuildingImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        stationBuildingImage.tintColor = UIColor(
            red: 255.0/255.0,
            green: 210.0/255.0,
            blue: 4.0/255.0,
            alpha: 1.0)
    }
        
    func setStationBuildingTitle(title: String) {
        stationBuildingLabel.text = title
    }
}
