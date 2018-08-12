//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Craig Scott on 8/9/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController {

    private let themes : [String : String] =
        ["Emoji" : "☺️😇😎😂😍😛",
         "Clothes" : "👚👕👖👔👗👙",
         "Animals" : "🐶🐱🐭🐹🐰🦊"]
    
    
    @IBAction func changeTheme(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Choose Theme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController{
                    
                    cvc.emojiChoices = theme
                    
                }
            }
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
