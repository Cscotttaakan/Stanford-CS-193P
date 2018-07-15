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
    private var strokeTextAttributes : [NSAttributedStringKey:Any] = [NSAttributedStringKey:Any]()
    private var manipulatedValue : String = ""
    private var value : NSAttributedString?
    
    init(shape : Shape, color : Color, number : Number, shading : Shading){
        
        /*properties = [AnyProperty(shape),AnyProperty(color),AnyProperty(number),AnyProperty(shading)] */
        
        self.color = color
        self.number = number
        self.shading = shading
        self.shape = shape
        
        properties = [AnyProperty(shape),AnyProperty(color),AnyProperty(number),AnyProperty(shading)]
        
        addProperty(attribute: shape)
        addProperty(attribute: color)
        addProperty(attribute: number)
        addProperty(attribute: shading)
        
        value = NSAttributedString(string: manipulatedValue, attributes: strokeTextAttributes)
        
        }
    //Spits back the rawValue of the card in NSAttributed String Form
    mutating func rawValue() -> NSAttributedString?{
        
        return value
    }
    //Takes in specific state and adds Dictionary definition to strokeAttributes using rawValue
    mutating func addProperty(attribute: Property){
        if( attribute is Shape){
            let tempShape = attribute as! Shape
            manipulatedValue = tempShape.rawValue
        }else if(attribute is Color){
            let tempColor = attribute as! Color
            strokeTextAttributes.merge(tempColor.rawValue, uniquingKeysWith: { _,_ in ((NSAttributedStringKey, Any) -> Any).self})
        }else if(attribute is Number){
            let tempNumber = attribute as! Number
            let tempString = manipulatedValue
            for _ in 0..<tempNumber.rawValue-1{
                manipulatedValue.append(tempString)
            }
        }else if(attribute is Shading){
            let tempShading = attribute as! Shading
            strokeTextAttributes.merge(tempShading.rawValue, uniquingKeysWith: { _,_ in ((NSAttributedStringKey, Any) -> Any).self})
            switch(tempShading)
            {
            case .Striped:
                strokeTextAttributes[.strokeColor] = color.rawValue[.strokeColor]?.withAlphaComponent(0.25)
                strokeTextAttributes[.foregroundColor] = color.rawValue[.strokeColor]?.withAlphaComponent(0.25)
            case.Outlined:
                strokeTextAttributes[.foregroundColor] = color.rawValue[.strokeColor]?.withAlphaComponent(1.0)
            default:
                strokeTextAttributes[.strokeColor] = color.rawValue[.strokeColor]
                strokeTextAttributes[.foregroundColor] = color.rawValue[.strokeColor]
            }
            
        }
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
            return left.rawValue[NSAttributedStringKey.strokeColor] == right.rawValue[.strokeColor]
        }
        else if lhs.property is Number{
            let left = lhs.property as! Number
            let right = rhs.property as! Number
            return left.rawValue == right.rawValue
        }
        else{
            let left = lhs.property as! Shading
            let right = rhs.property as! Shading
            return left.rawValue[.strokeWidth] == right.rawValue[.strokeWidth]
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
    case none
    
    static var allValues : [Property] {return [Number.One,Number.Two,Number.Three]}
}

enum Shading:Property {
    case Solid
    case Striped
    case Outlined
    case none
    
    static var allValues : [Property] {return [Shading.Solid,Shading.Striped,Shading.Outlined]}
}



//Create raw value in the form of Dictionary to add to textAttributes
extension Color:RawRepresentable{
    init?(rawValue: [NSAttributedStringKey : UIColor]) {
        switch(rawValue[.strokeColor]){
        case UIColor.red?:
                self = Color.Red
        case UIColor.green?:
                self = Color.Green
            case UIColor.blue?:
                self = Color.Blue
            default:
                self = Color.none
        }
    }
    
    var rawValue: [NSAttributedStringKey:UIColor] {
        switch(self){
            case .Red:
                return [.strokeColor:UIColor.red,.foregroundColor: UIColor.red]
            case .Green:
                return [.strokeColor:UIColor.cyan,.foregroundColor: UIColor.cyan]
            case .Blue:
                return [.strokeColor:UIColor.blue,.foregroundColor: UIColor.blue]
            default:
                return [.strokeColor:UIColor.clear,.foregroundColor: UIColor.clear]
        }
    }

}
//Create raw representable to add to stroke text attributes
extension Shading:RawRepresentable{
    init?(rawValue: [NSAttributedStringKey : Int]) {
        switch rawValue[.strokeWidth]!{
        case -2:
            self = Shading.Solid
        case 10:
            self = Shading.Outlined
        case -1:
            self = Shading.Striped
        default:
            self = Shading.none
        }
    }
    
    var rawValue: [NSAttributedStringKey: Int] {
        switch(self){
        case .Solid:
            return [.strokeWidth:-2]
        case .Outlined:
            return [.strokeWidth: 10]
        case .Striped:
            return [.strokeWidth: -1]
        default:
            return [.strokeColor:0]
        }
    }
    
}

