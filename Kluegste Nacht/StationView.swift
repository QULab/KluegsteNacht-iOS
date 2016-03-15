//
//  StationView.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 21/03/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

protocol StationViewDelegate {
    func didSelectStation(station: Int)
}

class StationView : UIView {
    
//    @IBOutlet weak var stationLabel: UILabel!
//    @IBOutlet weak var stationImage: UIImageView!

    var currentStation: Int = 0
    var stationButtons: [UIButton] = []
    let stationButtonConnectionWith: CGFloat = 2.0
    let stationButtonBorderWidth: CGFloat = 2.0
    
    var delegate: StationViewDelegate?
    let stationViewBackgroundColor = UIColor.clearColor()
    let stationLabelTextColor = UIColor(
        red: 41.0/255.0,
        green: 128.0/255.0,
        blue: 185.0/255.0,
        alpha: 1.0)
    
    var stationButtonSelectedColor = UIColor(
        red: 255.0/255.0,
        green: 210.0/255.0,
        blue: 4.0/255.0,
        alpha: 1.0)

    let stationButtonNormalColor = UIColor.darkGrayColor()

    let stationButtonBorderColor = UIColor.lightGrayColor()

    var stationButtonConnectionColor = UIColor(
        red: 255.0/255.0,
        green: 210.0/255.0,
        blue: 4.0/255.0,
        alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        backgroundColor = stationViewBackgroundColor
//        stationLabel.textColor = stationLabelTextColor
        
//        stationImage.image = stationImage.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
//        stationImage.tintColor = stationLabelTextColor
    }
    
    
    override func drawRect(rect: CGRect) {
        
        // draw horizontal line connecting all stationButtons
        let firstStationButton = stationButtons.first
        let lastStationButton = stationButtons.last
        let center = (frame.maxY) / 2
        
        let connectionLineStartPoint = CGPointMake(
            firstStationButton!.frame.origin.x + firstStationButton!.frame.width/2,
            center)
        
        let connectionLineEndPoint = CGPointMake(
            lastStationButton!.frame.origin.x + lastStationButton!.frame.width/2,
            center)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        CGContextSetLineCap(context, kCGLineCapSquare)
        CGContextSetStrokeColorWithColor(context, stationButtonConnectionColor.CGColor)
        CGContextSetLineWidth(context, stationButtonConnectionWith)
        CGContextMoveToPoint(context,
            connectionLineStartPoint.x,
            connectionLineStartPoint.y)
        CGContextAddLineToPoint(context,
            connectionLineEndPoint.x,
            connectionLineEndPoint.y)
        CGContextStrokePath(context)
        CGContextRestoreGState(context)

    }
    
//    func setStationTitle(title: String) {
//        stationLabel.text = title
//    }
    
    func setItems(items: Array<NSDictionary>) {
        
        var previousButton: UIButton?
        let diameter = frame.height * 0.5
        
        for (index,value) in enumerate(items) {
            var stationButton = UIButton()
            
            self.addSubview(stationButton)
            stationButtons.append(stationButton)
            stationButton.tag = index
            stationButton.addTarget(self,
                action: "didSelectStationButton:",
                forControlEvents: .TouchUpInside)

            // appearance
            stationButton.layer.cornerRadius = diameter * 0.5
            stationButton.layer.borderWidth = stationButtonBorderWidth
            stationButton.layer.borderColor = stationButtonBorderColor.CGColor
            
            stationButton.layer.backgroundColor = stationButtonNormalColor.CGColor
            
            /* Layout constraints */
            stationButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            
            // width
            self.addConstraint(NSLayoutConstraint(
                item: stationButton,
                attribute: NSLayoutAttribute.Width,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: diameter))
            
            // height
            self.addConstraint(NSLayoutConstraint(
                item: stationButton,
                attribute: NSLayoutAttribute.Height,
                relatedBy: NSLayoutRelation.Equal,
                toItem: nil,
                attribute: NSLayoutAttribute.NotAnAttribute,
                multiplier: 1.0,
                constant: diameter))
            
            // spacing between buttons
            let multiplier: CGFloat = CGFloat(2*index + 2) / (CGFloat)(items.count + 1)
            self.addConstraint(NSLayoutConstraint(
                item: stationButton,
                attribute: NSLayoutAttribute.CenterX,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.CenterX,
                multiplier: multiplier,
                constant: 0))
            
            // vertically centered in container
            let center = (frame.maxY) / 2
            self.addConstraint(NSLayoutConstraint(
                item: stationButton,
                attribute: NSLayoutAttribute.CenterY,
                relatedBy: NSLayoutRelation.Equal,
                toItem: self,
                attribute: NSLayoutAttribute.Top,
                multiplier: 1.0,
                constant: center))
        }
        
        selectStation(currentStation)
    }
    
    func didSelectStationButton(stationButton: UIButton) {
        delegate!.didSelectStation(stationButton.tag)
    }
    
    func selectStation(station: Int) {
        currentStation = station
        
        for stationButton in stationButtons {
            stationButton.selected = (stationButton.tag == station)
            
            stationButton.layer.backgroundColor = (stationButton.selected)
                ? stationButtonSelectedColor.CGColor
                : stationButtonNormalColor.CGColor
        }
    }
    
}
