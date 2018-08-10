//
//  Concentration.swift
//  Concentration
//
//  Created by Craig Scott on 3/29/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//☺️😇😎😂😍😛
//👚👕👖👔👗👙
//🐶🐱🐭🐹🐰🦊
//🌕🌖🌗🌘🌑🌒
//🍏🍎🍐🍊🍋🍌
//🚗🚚🚜🏎🚓🚑
import UIKit
import Foundation

//Only classes get free initializer of vars are set

//Appending or doing any sort of assigning
//with structs copies them.
struct Concentration{
    
    
    private(set) var cards = [Card]()
    
    
    private(set)var score: Int = 0
//    private var themes : [[String]] =
//        [["☺️","😇","😎","😂","😍","😛"],
//         ["👚","👕","👖","👔","👗","👙"],
//         ["🐶","🐱","🐭","🐹","🐰","🦊"],
//         ["🌕","🌖","🌗","🌘","🌑","🌒"],
//         ["🍏","🍎","🍐","🍊","🍋","🍌"],
//         ["🚗","🚚","🚜","🏎","🚓","🚑"]]
    
    
         /*"🌕🌖🌗🌘🌑🌒",
         "🍏🍎🍐🍊🍋🍌",
         "🚗🚚🚜🏎🚓🚑"]*/
    
    
    private(set) var flipCount = 0
    
    
    
    private var indexOfOneAndOnlyFaceUpCard: Int?{
        get{
            return cards.indices.filter{cards[$0].isFaceUp}.oneAndOnly 
//            var foundIndex: Int? //Intialize optional int to check for face up card
//            for index in cards.indices{ // Cycle through cards
//                if cards[index].isFaceUp{
//                    if foundIndex == nil{ //If there is a face up card and foundIndex is empty, set it equal to foundIndex
//                        foundIndex = index
//                    } else{
//                        return nil //If there are no face up cards or there already is a foundIndex
//                                   //TODO: Is foundIndex a local variable that is instantiated each get call, or is it saved in                   memory?
//                    }
//                }
//            }
//            return foundIndex
        }
        set{
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    mutating func chooseCard(at index: Int)
    {
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards") //Makes sure this is true, otherwise crashes
        flipCount += 1;
        // TODO: This is important
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                //Check if cards match
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true;
                    cards[index].isMatched = true;
                    score += 2
                }
                cards[index].isFaceUp = true;
                
            }
            else{
                
                
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = index;
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        assert(numberOfPairsOfCards > 0, "Concentration.init: \(numberOfPairsOfCards)): chosen number not")
        //Create theme index to randomize which theme to choose
        
        for _ in 1...numberOfPairsOfCards //Add card and randomly insert into cards
        {
            let card = Card()
            cards.insert(card, at: cards.count.arc4Random)
            cards.insert(card, at: cards.count.arc4Random)
            
        }
        
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

extension Collection {
    var oneAndOnly: Element?{
        return count == 1 ? first : nil
    }
}
