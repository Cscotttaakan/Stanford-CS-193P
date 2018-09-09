//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Craig Scott on 9/8/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {
    var backgroundImage : UIImage? { didSet{setNeedsDisplay()} }
    

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in : bounds)
        // Drawing code
    }


}
