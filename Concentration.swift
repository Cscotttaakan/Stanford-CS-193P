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

import Foundation

//Only classes get free initializer of vars are set

//Appending or doing any sort of assigning
//with structs copies them.
class Concentration{
    
    var cards = [Card]()
    var emojiChoices : [String]
    lazy var emoji = [Int:String]()
    var score: Int = 0
    var themes : [Int:[String]] =
        [0:["☺️","😇","😎","😂","😍","😛"],
         1:["👚","👕","👖","👔","👗","👙"],
         2:["🐶","🐱","🐭","🐹","🐰","🦊"],
         3:["🌕","🌖","🌗","🌘","🌑","🌒"],
         4:["🍏","🍎","🍐","🍊","🍋","🍌"],
         5:["🚗","🚚","🚜","🏎","🚓","🚑"]]
    var flipCount = 0
    var indexOfOneAndOnlyFaceUpCard: Int?
    func chooseCard(at index: Int)
    {
        flipCount += 1;
        // TODO: This is important
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index{
                //Check if cards match
                if cards[matchIndex].identifier == cards[index].identifier{
                    cards[matchIndex].isMatched = true;
                    cards[index].isMatched = true;
                    score += 2
                }
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = nil;
                
            }
            else{
                
                var seenCards = [Card]()
                var cardSeen = false;
                //Either no cards or 2 cards face up
                for flipDownIndex in cards.indices{
                    
                    if cards[flipDownIndex].isFaceUp{
                        seenCards.append(cards[flipDownIndex])
                        cards[flipDownIndex].isSeen = true
                    }
                    
                    cards[flipDownIndex].isFaceUp = false;
                    
                    
                }
                if seenCards.count > 0
                {
                    for card in seenCards{
                        if card.isSeen{
                            cardSeen = true
                        }
                    }
                    if cardSeen{
                        score -= 1
                    }
                }
                cards[index].isFaceUp = true;
                indexOfOneAndOnlyFaceUpCard = index;
            }
        }
    }
    
    init(numberOfPairsOfCards: Int) {
        
        let themeIndex = Int(arc4random_uniform(UInt32(themes.count)))
        emojiChoices = themes[themeIndex]!
        for _ in 1...numberOfPairsOfCards
        {
            let card = Card()
            let randomIndex = Int(arc4random_uniform(UInt32(cards.count)))
            cards.append(card)
            cards.insert(card, at: randomIndex)
            
        }
        
    }
    
    
    
}
