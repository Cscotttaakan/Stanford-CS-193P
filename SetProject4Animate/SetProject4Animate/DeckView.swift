//
//  DeckView.swift
//  SetProject4Animate
//
//  Created by Craig Scott on 8/19/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit
class DeckView: UIView {
    var isEmpty = true { didSet{setNeedsDisplay() ; setNeedsLayout()} }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderWidth = 3.0
        self.layer.cornerRadius = 8.0
        self.tintColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.backgroundColor = UIColor.clear
        
        
    }
    
    override func draw(_ rect: CGRect) {
        
        let roundedRect = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
            if let cardBackImage = UIImage(named: "cardBack",in: Bundle(for: self.classForCoder), compatibleWith: traitCollection), !isEmpty{
                
                cardBackImage.draw(in: bounds)
            }
        
        
    }
    
}
