//
//  Set.swift
//  SetProject2
//
//  Created by Craig Scott on 7/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation
import UIKit

class Set{
    var cards = [Card]()
    var competitor = Computer()
    var cardsInPlay :[Int:Card] = [Int:Card]()
    var cardsHighlighted :[Int:Card] = [Int:Card]()
    var Score : Int = 0
    var wonRound = false
    private let startingCards = 12
    private let maxCards = 24
    
    
    init(){
        //Initialize 81 cards each with different attributes
        //If new property, would have to create another for loop to cycle through the extra values.
        //If new property has 3 types, then there would be 243 distinct cards.
        for shape in  Shape.allValues{
            for color in Color.allValues{
                for number in Number.allValues{
                    for shading in Shading.allValues{
                        cards.insert(Card(shape: shape as! Shape,color: color as! Color,number: number as! Number,shading: shading as! Shading), at: cards.count.arc4Random)
                        
                    }
                }
            }
        }
        //Initialize randomized cards in play
        for index in 0..<startingCards{
            let card = cards.remove(at: cards.count.arc4Random)
            cardsInPlay[index] = card
        }
        
    }
    
    func chooseCard(index: Int)
    {
        //Check Set
        if(cardsHighlighted.keys.contains(index))
        {
            cardsHighlighted.removeValue(forKey: index)
        }
        else if(cardsHighlighted.count == 3){
            if(checkSet(set: cardsHighlighted)){
                removeSet()
                Score += 1
                wonRound = true
                //gain points
            }
            else{
                //lose points
                Score -= 1
            }
            cardsHighlighted.removeAll()
        }
        //Add card into highlighted dictionary
        else{
            cardsHighlighted[index] = cardsInPlay[index]
        }
    }
    
    //Iterates through every combination in cards in play, except when any cards are the same
    //Tests a potential 3 set combination in checkSet
    func findSet() -> Bool{
        for firstTuple in cardsInPlay{
            for secondTuple in cardsInPlay{
                for thirdTuple in cardsInPlay{
                    if(firstTuple.value != secondTuple.value && secondTuple.value != thirdTuple.value && thirdTuple.value != firstTuple.value){
                        let potentialSet = [firstTuple.key : firstTuple.value,secondTuple.key : secondTuple.value,thirdTuple.key : thirdTuple.value]
                        if(checkSet(set: potentialSet)){
                        cardsHighlighted.removeAll()
                        cardsHighlighted.merge(dict: potentialSet)
                        return true
                        }
                    }
                }
            }
        }
        return false
    }
    //Adds 3 cards to the set
    func addCards(){
        if(cardsInPlay.count <= maxCards){
            var count = 0
            
                for index in 0..<maxCards{
                    if !cardsInPlay.keys.contains(index) && count < 3{
                        cardsInPlay[index] = cards.popLast()
                        count += 1
                        
                    }
                }
        }
    }
    //Removes simultaneously the 3 cards in cardsHighlighted and 3 cards from cardsInPlay
    func removeSet(){
        for key in cardsHighlighted.keys{
            cardsInPlay.removeValue(forKey: key)
        }
        cardsHighlighted.removeAll()
        
    }
    
    //Iterate through cards and check individual matches... For set conformance, match should either be 0 or 2, none or all match
    //To add new property, would have to add another if statement casting the property as AnyProperty<NewProperty>, and new varProperty = 0 to count
    func checkSet(set : [Int : Card])->Bool{
        var previousCard : Card = (set.first?.value)!
        for tuple in set{
            previousCard = tuple.value
        }
        var shapeMatch = 0
        var colorMatch = 0
        var numberMatch = 0
        var shadingMatch = 0
        for tuple in set{
            if tuple.value != previousCard{
                for index in 0..<previousCard.properties.count{
                    
                    if      tuple.value.properties[index] is AnyProperty<Shape>{
                        if( tuple.value.properties[index] as! AnyProperty<Shape> == previousCard.properties[index] as! AnyProperty<Shape>){
                            shapeMatch += 1
                        }
                    }
                    else if tuple.value.properties[index] is AnyProperty<Color>{
                        if( tuple.value.properties[index] as! AnyProperty<Color> == previousCard.properties[index] as! AnyProperty<Color>){
                            colorMatch += 1
                        }
                    }
                    else if tuple.value.properties[index] is AnyProperty<Number>{
                        if( tuple.value.properties[index] as! AnyProperty<Number> ==
                            previousCard.properties[index] as! AnyProperty<Number>){
                            numberMatch += 1
                        }
                    }
                    else if tuple.value.properties[index] is AnyProperty<Shading>{
                        if( tuple.value.properties[index] as! AnyProperty<Shading> == previousCard.properties[index] as! AnyProperty<Shading>){
                            shadingMatch += 1
                        }
                    }
                }
                previousCard = tuple.value
            }
        }
        
        return shapeMatch % 3 == 0 && colorMatch % 3 == 0 && numberMatch % 3 == 0 && shadingMatch % 3 == 0
  }
    

}



extension Int{
    var arc4Random: Int{
        if self > 0{
            return Int(arc4random_uniform(UInt32(self)))
        }
        else if self < 0{
            return -Int(arc4random_uniform(UInt32(self)))
        }
        else{
            return 0
        }
    }
}

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
