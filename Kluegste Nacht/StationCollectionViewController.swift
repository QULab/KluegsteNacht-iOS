//
//  StationCollectionViewController.swift
//  Kluegste Nacht
//
//  Created by Tilo Westermann on 21/03/15.
//  Copyright (c) 2015 Quality and Usability Lab, Telekom Innovation Laboratories, TU Berlin. All rights reserved.
//

import UIKit

class StationCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let buildings = ["Haus der Biochemie der TUB", "Haus des Windes der TUB", "Versuchsanstalt auf der Schleuseninsel der TUB", "Universitätsbibliotheken der TU Berlin und UdK Berlin im VOLKSWAGEN-Haus", "Haus der Eisenbahn der TUB", "Haus der Logistik der TUB"]
    let exhibitions = ["Nunc mollis, arcu vel placerat","Mauris accumsan arcu eget auctor","Donec malesuada gravida orci, at bibendum orci scelerisque in","Integer dignissim interdum mauris. Ut metus lacus, efficitur at consequat"]
    let descriptions = ["Sed eget sollicitudin arcu. Nulla facilisi. Aenean quis tortor vel nulla ornare porttitor. Proin ac tincidunt arcu. Etiam tincidunt dapibus enim et pretium. Cras quis fringilla magna. Aenean et ex convallis, interdum augue id, tristique libero.\n\nSuspendisse consequat lacus eu ex pretium, vel suscipit nibh posuere. Cras cursus metus sit amet enim convallis venenatis sit amet id nibh. Nunc vitae tellus eu dolor rhoncus ornare a quis libero. Donec pharetra sem in sem sagittis laoreet. Sed pellentesque molestie augue, a fringilla lectus bibendum vel. Vivamus sed blandit urna. Nam ultricies placerat quam et semper. Nam quis euismod ligula. Quisque malesuada posuere justo, commodo viverra elit interdum id. Etiam placerat efficitur metus.","Donec auctor aliquet ex. Aliquam pharetra nibh erat, aliquet porttitor libero consectetur sed. Etiam pellentesque odio eu dolor lacinia elementum. Aliquam tristique est sit amet lorem varius euismod. Vestibulum dui ipsum, vulputate ac urna quis, dapibus condimentum nunc. Mauris erat arcu, ornare ut pharetra rutrum, ullamcorper ut massa. Fusce fermentum arcu ac libero egestas, eu aliquet tellus aliquet.","Morbi facilisis laoreet magna, vestibulum efficitur lorem dignissim a. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris diam justo, tempus vel risus vel, convallis porta tortor. Nam ornare neque velit, et tristique leo dignissim ut. Suspendisse placerat dignissim nisi non vulputate. Duis in ultricies nibh. Duis sed justo felis. Aenean tincidunt dignissim commodo. Integer nisi nunc, auctor id nisi nec, hendrerit convallis est. Phasellus maximus arcu in quam molestie, at mattis leo laoreet. Cras magna ipsum, convallis quis urna ut, blandit blandit nisl.","Vestibulum vel auctor orci. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean sed ullamcorper lacus. Suspendisse consequat mauris quis cursus placerat. Vivamus eu erat et neque lobortis tristique a id nunc. Nullam ullamcorper neque vel ex convallis tempus. Etiam tincidunt dolor vel enim ullamcorper, non tempor diam eleifend. Suspendisse vulputate ante et fermentum commodo. Cras porta lacus massa, non malesuada elit pretium id. Vestibulum placerat malesuada mi sit amet sodales. Aenean sed quam pharetra, maximus sapien et, varius orci. Sed eget felis posuere, viverra nibh ac, iaculis urna. In hac habitasse platea dictumst.\n\nSed tincidunt congue mi, id ultricies orci maximus sed. Cras eget efficitur ipsum. Fusce eget luctus tellus, a semper purus. Nam sagittis, risus in vestibulum finibus, nibh erat aliquam augue, a sollicitudin odio mi non arcu. Integer eget ultrices felis, a volutpat orci. Curabitur ornare bibendum blandit. Ut ornare urna sed eros fermentum laoreet.","Fusce faucibus condimentum placerat. In vel elit est. Integer at purus ultricies, ultricies magna vitae, gravida lorem. Phasellus feugiat, purus ac mollis tristique, sapien libero dapibus turpis, non gravida nulla mi vitae augue. Sed eget maximus mi. Maecenas purus nisi, lacinia et placerat id, dignissim ut sem. Donec ut fringilla neque. Donec facilisis ac tellus in porttitor. Curabitur ut interdum tellus. Cras quis semper sapien. Curabitur vestibulum ex eu finibus congue. Aenean ligula sem, lacinia nec orci eu, rutrum tempus sapien. Nullam mattis consequat orci in porttitor. Morbi faucibus arcu lacus, vel tempor ante pretium sed.\n\nMaecenas felis mauris, auctor non ullamcorper et, fermentum et purus. Ut arcu neque, gravida ut tincidunt ut, porta sed urna. Duis tincidunt vulputate feugiat. Suspendisse suscipit pulvinar sapien. Aliquam vitae quam sit amet metus vehicula laoreet. Ut dapibus lorem et ipsum interdum congue a in massa. Praesent dapibus at orci quis vestibulum."]
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return buildings.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return exhibitions.count
    }
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView: StationBuildingHeaderView = collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                withReuseIdentifier: "stationBuildingHeaderView",
                forIndexPath: indexPath) as! StationBuildingHeaderView
            headerView.setStationBuildingTitle(buildings[indexPath.section])
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        
        return UICollectionReusableView()
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {

        let label:UILabel = UILabel(frame: CGRectMake(0, 0, collectionView.frame.width - 8 - 20 - 8 - 8, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = UIFont.systemFontOfSize(17.0)
        label.text = buildings[section]
        label.sizeToFit()
        
        return CGSize(width: collectionView.frame.width, height: label.frame.height + 16)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: ExhibitionCell = collectionView.dequeueReusableCellWithReuseIdentifier(
            "collectionViewCell",
            forIndexPath: indexPath) as! ExhibitionCell
        
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 1.0;
        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        cell.descriptionLabel.text = descriptions[indexPath.row]
        cell.titleLabel.text = exhibitions[indexPath.row]
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let labelHeight = heightForView(descriptions[indexPath.row],
            font: UIFont.systemFontOfSize(14.0),
            width: 264.0)
        let height = 115 + 8 + labelHeight + 8 + 40;
        return CGSizeMake(280, height)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    @IBAction func didSelectLocationButton(sender: UIButton) {
        
        let point: CGPoint = collectionView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = collectionView!.indexPathForItemAtPoint(point)!

    }
    
    @IBAction func didSelectFavoriteButton(sender: UIButton) {
        let point: CGPoint = collectionView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = collectionView!.indexPathForItemAtPoint(point)!
    }
    
    
    @IBAction func didSelectShareButton(sender: UIButton) {
        let point: CGPoint = collectionView!.convertPoint(sender.center, fromView: sender.superview)
        let indexPath: NSIndexPath = collectionView!.indexPathForItemAtPoint(point)!
        
        let building: String = buildings[indexPath.section]
        let exhibition: String = exhibitions[indexPath.row]
        
        let text = "\(exhibition) @ \(building) #lndw2015 @LNdWApp"
        let appURL: NSURL! = NSURL(string: "http://app.kluegste-nacht.de")
        
        let activityViewController = UIActivityViewController(activityItems: [text,appURL], applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
}