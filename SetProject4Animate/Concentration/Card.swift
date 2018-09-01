//
//  Card.swift
//  Concentration
//
//  Created by Craig Scott on 3/29/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation

//No inheritance in struct, similar to class
//Structs are value types, classes are reference types
//What does that mean?
//Value type, copied
//Classes, pointed to
struct Card: Hashable
{
    var hashValue: Int{return identifier}
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    
    var isFaceUp = false
    var isMatched = false
    var isSeen = false;
    private var identifier: Int
    
    private static var identifierFactory = 0
    
    static func getUniqueIdentifier() -> Int{
        
        identifierFactory += 1
        return identifierFactory
    }
    
    init()
    {
        self.identifier = Card.getUniqueIdentifier()
    }
}
