//
//  QULPersonalProgramTimeViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 14/05/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import Foundation
import UIKit

class QULPersonalProgramTimeViewController: UIViewController  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rangeSliderView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var lowerValueLabel: UILabel!
    @IBOutlet weak var upperValueLabel: UILabel!
    @IBOutlet weak var timespanLabel: UILabel!
    
    let locations: Array<String> = ["keine räumliche Einschränkung","Berlin-Buch","Treptow, Adlershof + Schöneweide","Treptow, Baumschulenweg","Treptow, Treptower Park","Neukölln, Buckow","Kreuzberg","Ostbahnhof + Jannowitzbrücke","Wedding + Mitte nördlicher Teil","Mitte südlicher Teil","Tiergarten, Hauptbahnhof + Moabit","Charlottenburg","Dahlem/Steglitz","Wannsee + Potsdam"]
    var selectedLocations: Array<String> = []
    var result = [String : AnyObject]()
    var start:Double = 16
    var end:Double  = 25
    
    let rangeSlider = RangeSlider(frame: CGRectZero)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rangeSlider.trackTintColor = UIColor.lightGrayColor()
        rangeSlider.trackHighlightTintColor = UIColor(
            red: 255.0/255.0,
            green: 210.0/255.0,
            blue: 4.0/255.0,
            alpha: 1.0)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(rangeSlider)
        rangeSlider.addTarget(self, action: "rangeSliderValueChanged:", forControlEvents: .ValueChanged)
        title = "Wann?"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rangeSlider.frame = rangeSliderView.frame
    }
        
    func rangeSliderValueChanged(rangeSlider: RangeSlider) {
        var colorAttrs = [NSForegroundColorAttributeName : UIColor(
            red: 255.0/255.0,
            green: 210.0/255.0,
            blue: 4.0/255.0,
            alpha: 1.0)]
        var stdColorAttrs = [NSForegroundColorAttributeName : UIColor.lightGrayColor()]
        
        start = 15 + round(rangeSlider.lowerValue)
        end = 15 + round(rangeSlider.upperValue)
        
        var startStr = String.localizedStringWithFormat("%.0f Uhr", start)
        var endStr = end == 25.0 ? "Open end" : String.localizedStringWithFormat("%.0f Uhr", end)
        
        var timespan = NSMutableAttributedString(string:"\(startStr)", attributes: colorAttrs)
        timespan.appendAttributedString(NSMutableAttributedString(string:" bis ", attributes: stdColorAttrs))
        var upperValueString = NSMutableAttributedString(string:"\(endStr)", attributes: colorAttrs)
        timespan.appendAttributedString(upperValueString)
        
        
        timespanLabel.attributedText = timespan
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // hand over selected timespan
        let topicsController:QULPersonalProgramTopicsViewController = segue.destinationViewController as! QULPersonalProgramTopicsViewController
        var timespan = [String:Double]()
        timespan["start"] = start
        if (end < 25.0) {
            timespan["end"] = end
        }
        result["Timespan"] = timespan
        topicsController.result = result
    }
}