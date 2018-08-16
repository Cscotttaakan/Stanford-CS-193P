//
//  PlayingCard.swift
//  PlayingCard
//
//  Created by Craig Scott on 6/29/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

//Create a UI independent model

import Foundation

struct PlayingCard : CustomStringConvertible {
    var suit : Suit
    var rank : Rank

    var description: String { return "\(rank)\(suit)" }
    
    
    enum Suit : String, CustomStringConvertible{
        
        var description: String {return self.rawValue}
        
        case spades = "♠️"
        case hearts = "❤️"
        case diamonds = "♦️"
        case clubs = "♣️"
        
        static var all : [Suit] = [Suit.spades,.hearts,.diamonds,.clubs]
    }
    
    enum Rank : CustomStringConvertible{
        case ace
        case face(String)
        case numeric(Int)
        
        var order: Int{
            
            switch self{
            case .ace: return 1
            case .numeric(let pips): return pips
            case .face(let kind) where kind == "J": return 11
            case .face(let kind) where kind == "Q": return 12
            case .face(let kind) where kind == "K": return 13
            default: return 0
            }
        }
        static var all : [Rank] {
            var allRanks = [Rank.ace]
            for pips in 2...10{
                allRanks.append(Rank.numeric(pips))
            }
            allRanks += [Rank.face("J"),Rank.face("Q"),Rank.face("K")]
            
            return allRanks
            
        }
        
        var description: String {
            switch(self){
            case .ace: return "A"
            case .numeric(let pips): return String(pips)
            case .face(let kind): return String(kind)
            }
        }
       
    }
 }
