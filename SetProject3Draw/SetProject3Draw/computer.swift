//
//  computer.swift
//  SetProject2
//
//  Created by Craig Scott on 7/14/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import Foundation

struct Computer{
    var state : computerState = .Neutral
    var difficulty : Difficulty = .easy
}

enum computerState : String{
    case Thinking = "🤔"
    case Almost = "😁"
    case Win = "🤣"
    case Lost = "😓"
    case Neutral = "😐"
}

enum Difficulty : Int{
    case easy = 24
    case challenging = 18
    case hard = 12
}
