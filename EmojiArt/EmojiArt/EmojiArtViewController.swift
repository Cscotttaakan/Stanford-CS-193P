//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Craig Scott on 9/8/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate , UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    

    var imageFetcher : ImageFetcher!
    var emojiArtView = EmojiArtView()
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var emojiCollectionView: UICollectionView! {
        didSet {
            emojiCollectionView.dataSource = self
            emojiCollectionView.delegate = self
        }
        
    }
    
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.minimumZoomScale = 0.1
            scrollView.maximumZoomScale = 5.0
            scrollView.delegate = self
            scrollView.addSubview(emojiArtView)
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        scrollViewHeight?.constant = scrollView.contentSize.height
        scrollViewWidth?.constant = scrollView.contentSize.width
    }
    
    @IBOutlet weak var dropZone: UIView! {
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate :  self))
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session : UIDropSession) -> Bool  {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass : UIImage.self )
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        imageFetcher = ImageFetcher() { (url , image) in
            
            DispatchQueue.main.async {
                self.emojiArtBackgroundImage  = image
            }
            
        }
        
        
        session.loadObjects(ofClass: NSURL.self) { nsurls in
            
            if let url = nsurls.first as? URL{
                self.imageFetcher.fetch(url)
            }
            
            
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return emojiArtView
    }
    
    var emojiArtBackgroundImage : UIImage? {
        get {
            return emojiArtView.backgroundImage
        }
        set {
            scrollView?.zoomScale = 1.0
            emojiArtView.backgroundImage = newValue
            let size = newValue?.size ?? CGSize.zero
            emojiArtView.frame = CGRect(origin : CGPoint.zero , size : size)
            scrollView?.contentSize = size
            scrollViewWidth?.constant = size.width
            scrollViewHeight?.constant = size.height
            if let dropZone = self.dropZone, size.width > 0 , size.height > 0{
                scrollView?.zoomScale = max(dropZone.bounds.size.width / size.width , dropZone.bounds.size.height / size.height)
            }
        }
    }
    
    var emojis = "🎟🥉🚙🎲"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    

}
