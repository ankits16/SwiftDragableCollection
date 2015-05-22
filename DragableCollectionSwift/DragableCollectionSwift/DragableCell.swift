//
//  DragableCell.swift
//  DragableCollectionSwift
//
//  Created by Ankit Sachan on 5/21/15.
//  Copyright (c) 2015 Ankit Sachan. All rights reserved.
//

import UIKit

class DragableCell: UICollectionViewCell {
    
    var index:Int?
    var optionImageView:UIImageView?
    var optionLbl:UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func startQuivering(){
        let quiverAnim = CABasicAnimation(keyPath: "animationWithKeyPath")
        
        let startAngle = (-2) * M_PI/180.0
        let stopAngle = -startAngle
        let timeOffset = (Float((arc4random() % 100))/100) - 0.50
        
        quiverAnim.fromValue = NSNumber(double: startAngle)
        quiverAnim.toValue = NSNumber(double: 3 * stopAngle)
        quiverAnim.autoreverses = true
        quiverAnim.duration = 0.2
        quiverAnim.repeatCount = Float.infinity
        quiverAnim.timeOffset = CFTimeInterval(timeOffset)
        
        let layer = self.layer
        self.layer.rasterizationScale = UIScreen.mainScreen().scale
        self.layer.shouldRasterize = true
        layer.addAnimation(quiverAnim, forKey: "quivering")
    }
    
    func stopQuivering(){
        let layer = self.layer
        layer.removeAnimationForKey("quivering")
    }
}
