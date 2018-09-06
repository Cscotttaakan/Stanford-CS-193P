//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Craig Scott on 9/5/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier, let url = DemoURLs.NASA[identifier],
           let imageVC = segue.destination as? ImageViewController {
            imageVC.imageURL = url
            imageVC.title = (sender as? UIButton)?.currentTitle
            
        }
        
    }
    

}
