//
//  ImageViewController.swift
//  Cassini
//
//  Created by Craig Scott on 9/1/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL : URL?{
        didSet{
            imageView.image = nil
            if view.window != nil{
                fetchImage()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if imageView == nil{
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func fetchImage(){
        if let url = imageURL {
           
            let urlContents = try? Data(contentsOf: url)
            
            if let imageData = urlContents{
                imageView.image = UIImage(data : imageData)
            }
            
        }
    }
    
    

}
