//
//  CardView.swift
//  SetProject2Draw
//
//  Created by Craig Scott on 7/28/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit
import CoreGraphics


class CardView: UIView {

    var color : Color
    var shape : Shape
    var number : Number
    var shading : Shading
    //Position X
    var offsetX : CGFloat
    //Position Y
    var offsetY : CGFloat
    var cgColor : UIColor
    var maxShapeLength : CGFloat { return bounds.maxX / 4}
    var isFaceUp = false { didSet{ setNeedsDisplay(); setNeedsLayout()  } }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    
    
    override init(frame: CGRect) {
        self.color = .none
        self.shape = .none
        self.number = .none
        self.shading = .none
        offsetX = CGFloat(0)
        offsetY = CGFloat(0)
        cgColor = UIColor.clear
        super.init(frame: frame)
        
    }
    
    convenience init(frame: CGRect, shape : Shape, color : Color, number : Number, shading : Shading){
        self.init(frame: frame)
        self.color = color
        self.shape = shape
        self.number = number
        self.shading = shading
        self.layer.borderWidth = 3.0
        self.layer.cornerRadius = 8.0
        self.tintColor = UIColor.clear
        self.layer.backgroundColor = UIColor.clear.cgColor
        self.layer.borderColor = UIColor.darkGray.cgColor
        self.backgroundColor = UIColor.clear
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.color = .Green
        self.shape = .Triangle
        self.number = .Three
        self.shading = .Striped
        offsetX = CGFloat(0)
        offsetY = CGFloat(0)
        cgColor = UIColor.clear
        super.init(coder: aDecoder)
        
    }
    
    deinit {
        
    }
    
    override func layoutSubviews() {
        switch(color){
        case .Blue:
            cgColor = UIColor.blue
        case .Red:
            cgColor = UIColor.red
        case .Green:
            cgColor = UIColor.green
        default:
            break
        }
        offsetX = bounds.maxX / CGFloat(number.rawValue + 1)
        offsetY = bounds.maxY / 2
        setNeedsDisplay()
    }
    
    func highlightBorder(){
        
        self.layer.borderColor = UIColor.blue.cgColor
        
        }
    
    func regularBorder(){
        self.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        if isFaceUp{
        let padding : CGFloat = 2
        
        // Drawing code
        for index in 1...number.rawValue{
            let spacing : CGFloat = offsetX * CGFloat(index)
            //pads left, then 0 padding, then pads right for even spacing
            let variablePadding = padding * CGFloat(index - number.rawValue )
            // x = offsetX * index - (padding * (number.value - 1))
            drawShape(with: path, at: CGPoint(x: spacing + variablePadding, y: offsetY))
            
        }
        if(shading == .Striped){
            path.addClip()
            for index in 1...number.rawValue{
                let spacing : CGFloat = offsetX * CGFloat(index)
                //pads left, then 0 padding, then pads right for even spacing
                let variablePadding = padding * CGFloat(index - number.rawValue )
                // x = offsetX * index - (padding * (number.value - 1))
                drawShading(with: path, at: CGPoint(x: spacing + variablePadding, y: offsetY))
                
            }
        }
        
        
    //drawCircle(with: path)
        }else{
            if let cardBackImage = UIImage(named: "cardBack",in: Bundle(for: self.classForCoder), compatibleWith: traitCollection){
                
                cardBackImage.draw(in: bounds)
            }
        }
        
    }
    
    func drawShape(with path: UIBezierPath, at point : CGPoint){
        
        switch(shape){
        case .Triangle:
            drawTriangle(with: path, at: point)
        case .Circle:
            drawCircle(with: path,at: point)
        case .Square:
            drawSquare(with: path,at: point)
        default:
            break
            
        }
    }
    
    func drawShading(with path: UIBezierPath, at point : CGPoint){
        let granularity : CGFloat = 8
        let distanceFromOrigin : CGFloat = maxShapeLength / 2
        let distanceBetweenLines : CGFloat = maxShapeLength / granularity
        for index in 1...Int(granularity){
            let padding : CGFloat = CGFloat(index) * distanceBetweenLines
            path.move(to: CGPoint(x: point.x - distanceFromOrigin,y: point.y + distanceFromOrigin - padding))
            path.addLine(to: CGPoint(x: point.x + distanceFromOrigin,y: point.y + distanceFromOrigin - padding))
        }
        addLine(with: path)
        //addFill(for: path)
        path.lineWidth = path.lineWidth / (granularity / 3)
        path.stroke()
    }
    
    func drawTriangle(with path : UIBezierPath, at point : CGPoint){
        let weight : CGFloat = 0.85
        let distanceFromOrigin = (maxShapeLength / 2) * weight
        
        path.move(to: CGPoint(x: point.x , y: point.y - distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x + distanceFromOrigin,y: point.y + distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x - distanceFromOrigin,y: point.y + distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x , y: point.y - distanceFromOrigin))
        addLine(with: path)
        addFill(for: path)
        
        path.stroke()
    }
    
    func drawSquare(with path : UIBezierPath, at point : CGPoint){
        let weight : CGFloat = 0.85
        let distanceFromOrigin = (maxShapeLength / 2) * weight
        path.move(to: CGPoint(x: point.x - distanceFromOrigin,y: point.y + distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x + distanceFromOrigin,y: point.y + distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x + distanceFromOrigin,y: point.y - distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x - distanceFromOrigin,y: point.y - distanceFromOrigin))
        path.addLine(to: CGPoint(x: point.x - distanceFromOrigin,y: point.y + distanceFromOrigin))
        addLine(with: path)
        addFill(for: path)
        path.stroke()
    }
    
    func drawCircle(with path : UIBezierPath, at point : CGPoint){
        let weight : CGFloat = 0.85
        let distanceFromOrigin = (self.bounds.midX / 4) * weight
        path.move(to: CGPoint(x: point.x + distanceFromOrigin, y: point.y))
        path.addArc(withCenter: point, radius: distanceFromOrigin, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        addLine(with: path)
        addFill(for: path)
        
        path.stroke()
    }
    
    func addLine(with path : UIBezierPath){
        path.lineWidth = 2
        cgColor.setStroke()
    }
/*
    func drawCircle(with path: UIBezierPath, at position: CGPoint){
        bounds.minX
        path.addArc(withCenter: CGPoint(x: bounds.midX,y: bounds.midY), radius: self.bounds.midX / 3, startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        path.lineWidth = 5
        UIColor.blue.setStroke()
        path.stroke()
        
    }
 */
    
    func addFill(for path: UIBezierPath){
       
        switch(shading){
        case .Outlined:
            
            break
        case .Solid:
            cgColor.setFill()
            path.fill()
            break
        default:
            break
        }
        
        
        
    }
    
}

extension Int{
    func float() ->Float{
        return Float(self)
    }
}
