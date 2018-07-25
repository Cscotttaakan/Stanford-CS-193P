//
//  .swift
//  SetProject2
//
//  Created by Craig Scott on 7/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//
//To add new property would have to change Equatable protocol
//Create new private(set) var newproperty : NewProperty = NewProperty.none
//Add the init command for the new property in init()
//Have to do addProperty(NewProperty) in init()
//Change addProperty() to have a new conditional else if case with specific NSAttributedTextKey
//Have to modify AnyProperty<P:Property>() equatable protocol to include extra property comparison
//Create enum for property
//Create rawRepresentable in the form of [NSAttributedString:Key] so you can merge the dictionary with strokeTextAttributes
//The whole point was to create a raw representable form of the stroke text attributes based on a specific enum state.
import UIKit
import Foundation

struct Card : Equatable{
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return (lhs.shape == rhs.shape   &&
                lhs.color == rhs.color   &&
                lhs.number == rhs.number &&
                lhs.shading == rhs.shading)
    }
    
    //So easy to check if cards are the same
    
    
    
    private(set) var shape : Shape = Shape.none
    private(set) var color : Color = Color.none
    private(set) var number : Number = Number.none
    private(set) var shading : Shading = Shading.none
    
    private(set) var properties: [Property]
    
    init(shape : Shape, color : Color, number : Number, shading : Shading){
        
        
        self.color = color
        self.number = number
        self.shading = shading
        self.shape = shape
        
        properties = [AnyProperty(shape),AnyProperty(color),AnyProperty(number),AnyProperty(shading)]
        

        
        }

    
}
        
        


protocol Property{
    static var allValues : [Property] {get}
}

//Have to hardcode equatable of any property for generic array of properties, to compare
struct AnyProperty<P: Property>: Property,Equatable{
    static func ==(lhs: AnyProperty<P>, rhs: AnyProperty<P>) -> Bool {
        
        if(lhs.property is Shape){
            let left = lhs.property as! Shape
            let right = rhs.property as! Shape
            return left.rawValue == right.rawValue
        }
        else if lhs.property is Color{
            let left = lhs.property as! Color
            let right = rhs.property as! Color
            return left == right
        }
        else if lhs.property is Number{
            let left = lhs.property as! Number
            let right = rhs.property as! Number
            return left.rawValue == right.rawValue
        }
        else{
            let left = lhs.property as! Shading
            let right = rhs.property as! Shading
            return left == right
        }
    }
    
    let property: P
    
    init(_  property : P) {
        self.property = property
    }
    
    static var allValues : [Property] {get{return P.allValues}}
}




enum Shape : String,Property{

    case Square = "■"
    case Triangle = "▲"
    case Circle = "●"
    case none
    static var allValues : [Property]{ return [Square,Shape.Triangle,Shape.Circle]}
    
    
}

enum Color:Property  {
    static var allValues: [Property] {return [Color.Red,Color.Green,Color.Blue]}
    
    
    case Red
    case Green
    case Blue
    case none
}

enum Number : Int,Property{
    case One = 1
    case Two = 2
    case Three = 3
    case none = 0
    
    static var allValues : [Property] {return [Number.One,Number.Two,Number.Three]}
    
}

enum Shading:Property {
    case Solid
    case Striped
    case Outlined
    case none
    
    static var allValues : [Property] {return [Shading.Solid,Shading.Striped,Shading.Outlined]}
}



