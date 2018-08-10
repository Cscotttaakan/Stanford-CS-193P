//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Craig Scott on 8/8/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let themes : [String : String] =
        ["Emoji" : "☺️😇😎😂😍😛",
         "Clothes" : "👚👕👖👔👗👙",
         "Animals" : "🐶🐱🐭🐹🐰🦊"]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Choose Theme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.emojiChoices = theme
                }
            }
        }
    }
 
}
