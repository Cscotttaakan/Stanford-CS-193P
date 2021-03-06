//
//  ViewControllerExtensionViewController.swift
//  SetProject4Animate
//
//  Created by Craig Scott on 8/19/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit
import Darwin
extension UIViewController{
    
    //Function that translates card from its position to position A
    //Moving from A to B, in final reference frame you're moving to
    //In this case GridView
    func move( this view : UIView, fromPositionOf A : UIView , toPositionOf B : UIView , delay : Double, callback: @escaping (() -> ()) ){
        var endPoint : CGPoint
        
        //Must subtract view origin and and end frame of reference
        endPoint = B.frame.origin - view.superview?.frame.origin + B.superview?.frame.origin
        
        //Must subtract own frame of reference then add beginning frame of reference
        view.frame.origin = A.frame.origin - view.superview?.frame.origin + A.superview?.frame.origin
        //let debouncedFunction = Debouncer(delay: delay) {
        UIView.animate(withDuration: Constants.translateTime,
                       animations: {
                        view.frame.origin = endPoint },
                       completion: { Void in
                callback()
            })
        
    //}
        
        //debouncedFunction.call()
    }
    
    
    
    //Function that flips the card
    func flipCard ( view : UIView , delay : Double){
        if let card = view as? CardView{
            //let debouncedFunction = Debouncer(delay : delay) {
            UIView.transition(with: card,
                              duration: Constants.flipTime,
                              options: [.transitionFlipFromLeft],
                              animations: {
                                card.isFaceUp = !card.isFaceUp
                                
            } )
            //}
            //debouncedFunction.call()
        }
    }
    
    //Function that pushes goes from size A to Size B
    func resize( from A : UIView , to B : UIView , delay : Double){
        
        let debouncedFunction = Debouncer(delay: delay) {
        UIView.animate(withDuration: Constants.translateTime,
                       animations: {
                         A.frame.size = B.frame.size },
                       completion: nil)
    }
        debouncedFunction.call()
    
    }
    
    
}

//Allow there to be reference frame adjustments
extension CGPoint{
    static func +(lhs: CGPoint, rhs: CGPoint?) -> CGPoint {
        if let point : CGPoint = rhs{
            return CGPoint(x: lhs.x + point.x , y: lhs.y + point.y)
        }
        else{
            return lhs
        }
        
    }
    
    static func -(lhs: CGPoint, rhs: CGPoint?) -> CGPoint {
        if let point : CGPoint = rhs{
            return CGPoint(x: lhs.x - point.x, y: lhs.y - point.y)
        }
        else{
            return lhs
        }
        
    }
}


