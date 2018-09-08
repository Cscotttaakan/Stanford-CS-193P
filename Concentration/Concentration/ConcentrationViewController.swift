//
//  ViewController.swift
//  Concentration
//
//  Created by Craig Scott on 3/28/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

// In this demo, we are creating a flip card app.
// ---------------------------------------------
/*
 Create buttons in the story board on the right hand column.
 Resize and edit the object in attribute inspector in the right hand column.
 
 We are utilizing Swift's UI Controller interface
 to dynamically create functions.
 You may drag and drop GUI elements into the ViewController.
 
 On the top right, it shows two venn-diagram rings, click that to show both windows.
 One window must contain the source code, and the other the storyboard.
 
 You can drag and drop using: control and then dragging the element to the source code.
 */

import UIKit

class ConcentrationViewController: UIViewController {
    var emoji = [Card:String]()
    private var themes : [String] =
        ["☺️😇😎😂😍😛",
         "👚👕👖👔👗👙",
         "🐶🐱🐭🐹🐰🦊"]
    var emojiChoices : String = ""
    
    var theme : String?{ didSet{
        emojiChoices = theme ?? ""
        emoji = [:]
        updateViewFromModel()
        }
    }
    //Classes in Swift get a free init, as long as vars are initialized
    //Lazy allows us to call vars & their functions
    //without the var being initialized
    //Delayed assignment almost
    private lazy var game = Concentration(numberOfPairsOfCards :numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int{
        
        return (visibleButtons.count+1)/2
        
    }
    //Swift is extremely type-cast heavy, but also
    //type inference heavy.
    
    
    private var visibleButtons : [UIButton]! {
        return cardButtons?.filter{  !$0.superview!.isHidden }
    }
    
    private func updateFlipCount(count : Int){
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth: 5.0,
            .strokeColor: #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(count)",attributes :attributes )
        flipCountLabel.attributedText = attributedString
        
    }
    
    private func initializeFlipCount(){
        updateFlipCount(count: 0)
    }
    
    
    
    //CMD + click -> rename
    @IBOutlet weak var flipCountLabel: UILabel!{
        didSet{
            initializeFlipCount()
        }
    }
    
    
    @IBOutlet weak var gameScore: UILabel!
    //Array of UIButtons
    @IBOutlet var cardButtons: [UIButton]!
    
    
    @IBAction func NewGame(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: (visibleButtons.count+1)/2)
        updateViewFromModel()
    }
    
    
    //We now have connected the second button
    //to this function.
    //We are now using array of labels in visibleButtons variable
    @IBAction private func TouchCard(_ sender: UIButton) {
        
        //The use of optionals:
        //--------------------
        //Put exclamation ! at end of optional to unwrap
        //Will throw error if contains nil, so we use if let
        //to use a condition to check if the optional contains an unwrappable
        //value
        if let cardNumber = visibleButtons.index(of: sender)
        {
            game.chooseCard(at: cardNumber)
            
            
            updateViewFromModel()
        }
            
        else{
            print("card not in array")
        }
        
        //Sends ghost emoji to flip card function
        //flipCard(withEmoji: "👻", on: sender)
    }
    
    
    
    
    
    
    //This is using MVC design, have Concentration class & Card Class
    //Using update view from model, we only use visibleButtons which is from
    //the story board. We then use the game variable to access its card
    //array. We drastically reduce code using this format.
    private  func updateViewFromModel(){
        guard visibleButtons != nil else { return }
        let count = game.flipCount
        let score = game.score
        for index in visibleButtons.indices{
            let button = visibleButtons[index]
            let card = game.cards[index]
            
            
            if card.isFaceUp{
                button.setTitle(emoji(for:card), for: UIControlState.normal);
                
                button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1);
            }
            else{
                button.setTitle("", for: UIControlState.normal);
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0) : #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
            }
            
        }
        
        updateFlipCount(count: count)
        //gameScore.text = "Game Score: \(score)";
        
    }
    
    //This second function was created by copying
    //The ghost button and dragging and dropping
    //the function.
    //Unfortunately, by copying and pasting
    //The pumpkin button was also connected to the above
    //function. You must right click and delete the
    //relation between the first function and the
    //pumpkin button.
    
    //We remove this function because it is bad programming practice
    //to have to copy and paste each button function.
    //We want to create a function that is general and can take
    //multiple button classes.
    //We do this by dragging and dropping multiple buttons
    //to the same function.
    /*
     @IBAction func TouchSecondCard(_ sender: UIButton) {
     flipCount += 1;
     flipCard(withEmoji: "🎃", on: sender)
     }
     */
    
    // Flip card takes in emoji and button class.
    // It then checks the contents of button against the emoji variable
    // Depending on the emoji variable, it has associated responses
    // It will either show the ghost emoji, or it will make the button blank
    // Hence the "flip card"
    
    
    /*
     func flipCard(withEmoji emoji: String, on button: UIButton)
     {
     if(button.currentTitle == emoji)
     {
     button.setTitle("", for: UIControlState.normal);
     //Interestingly, you can set attributes to literals, click the box to change the color.
     button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1);
     }
     else{
     button.setTitle(emoji, for: UIControlState.normal);
     button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1);
     }
     }
     */
    
    
    
    
    
    private func emoji(for card: Card) -> String {
        
        
        
        //Want to show why this piece of code works
        // So it initially takes a card struct, checks if there is an associated value
        // In the dictionary. If there's not, and there are still values in emojiChoices
        // Then choose a random String from emojiChoices. Remove it from the array
        // Then return the new emoji for that card.
        // Why is it returning the same card for the one directly after it?
        if emoji[card] == nil, emojiChoices.count > 0{
            let randomIndex = emojiChoices.count.arc4Random
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: randomIndex)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
            
        }
        
        /*
         if emoji[card.identifier] != nil{
         return emoji[card.identifier]!
         }
         else{
         return "?"
         }
         */
        
        //Short-hand way to write above
        return emoji[card] ?? "?"
    }
    
}
