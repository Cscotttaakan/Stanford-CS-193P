//
//  ConcentrationThemeChooserViewController.swift
//  Concentration
//
//  Created by Craig Scott on 8/9/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate {
    
    func splitViewController(_
        splitViewController: UISplitViewController,
                             collapseSecondary secondaryViewController: UIViewController,
                             onto primaryViewController: UIViewController
        ) -> Bool {
        
        if let cvc = secondaryViewController as? ConcentrationViewController{
            if cvc.theme == nil{
                return true
            }
        }
        return false
        
    }
    
    private let themes : [String : String] =
        ["Emoji" : "☺️😇😎😂😍😛",
         "Clothes" : "👚👕👖👔👗👙",
         "Animals" : "🐶🐱🐭🐹🐰🦊"]
    
    private var splitViewDetailConcentrationViewController  : ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    private var lastSeguedToConcentrationViewController : ConcentrationViewController?
    
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                cvc.theme = theme
            }
        }
        else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                
                
                cvc.theme = theme
                
            }
            navigationController?.pushViewController(cvc, animated: true)
        }
        else{
            
            performSegue(withIdentifier: "Choose Theme", sender: sender)
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "Choose Theme"{
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName]{
                if let cvc = segue.destination as? ConcentrationViewController{
                    
                    cvc.theme = theme
                    lastSeguedToConcentrationViewController = cvc
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
