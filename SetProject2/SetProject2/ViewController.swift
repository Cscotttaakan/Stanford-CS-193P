//
//  ViewController.swift
//  SetProject2
//
//  Created by Craig Scott on 7/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var game : Set = Set()
    private var isTimerRunning = false
    private var time = 0
    private var timer = Timer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize button styles
        for index in 0..<cardButtons.count{
            cardButtons[index].layer.borderWidth = 3.0
            cardButtons[index].layer.cornerRadius = 8.0
            cardButtons[index].tintColor = UIColor.clear
            cardButtons[index].remove()
        }
        
    }

    @IBOutlet weak var Score: UILabel!
    @IBAction func addCards(_ sender: UIButton) {
        resetOnGoingGame()
        game.addCards()
        updateViewFromModel()
    }
    @IBAction func NewGame(_ sender: UIButton) {
        time = 0
        game = Set()
        updateViewFromModel()
        if(!isTimerRunning){
            runTimer()
            isTimerRunning = true
        }
    }
    
    func resetOnGoingGame(){
        updateViewFromModel()
        time = 0
        game.clearHighlight()
    }
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func TouchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.index(of: sender){
            updateViewFromModel()
            game.chooseCard(index: cardNumber)
            updateViewFromModel()
            
            
        }else{
            
        }
        
    }
    
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var computerState: UILabel!
    
    
    private func updateViewFromModel(){
        drawCards()
        drawHighlighted()
        removeCardsNotInPlay()
        Score.text = "Score: \(game.Score)"
        
        
    }
    
    private func drawCards(){
        for index in 0..<game.maxCards{
            if let card = game.cardsInPlay[index]{
            cardButtons[index].draw(string: cardToString(from: card))
            }
        }
    }
    
    private func drawHighlighted(){
        for key in game.cardsHighlighted.keys{
            cardButtons[key].highlight()
        }
    }
    
    private func removeCardsNotInPlay(){
        for index in 0..<cardButtons.count{
            if !game.cardsInPlay.keys.contains(index){
                cardButtons[index].remove()
            }
        }
    }
    

    private func runTimer(){
        timer = Timer.scheduledTimer(timeInterval : 1,target : self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats : true)
    }
    
    @objc private func updateTimer(){
        if game.wonRound{
            game.competitor.state = .Lost
            time = 0
            game.wonRound = false
        }
            
        else if(time == game.competitor.difficulty.rawValue && !game.wonRound){
            resetOnGoingGame()
            if(game.findSet()){
 

                game.competitor.state = .Win
                game.removeSet()
                game.wonRound = false
                game.Score -= 2
                
            }
            else{
                game.addCards()
            }
            
        }
        else if time == game.competitor.difficulty.rawValue / 3 {
            game.competitor.state = .Thinking
        }
        else if time == game.competitor.difficulty.rawValue / 2{
            game.competitor.state = .Almost
        }
        
        time += 1
        gameTime.text = "Time: \(time)"
        computerState.text = "Computer: \(game.competitor.state.rawValue)"
        updateViewFromModel()
    }
}


//Create extension to "draw" the proper button based on NSAttributedString
extension UIButton{
    func draw(string : NSAttributedString?){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        self.setAttributedTitle(string,for: UIControlState.normal)
    }
    
    func highlight(){
        self.layer.borderColor = UIColor.blue.cgColor
    }
    
    func remove(){
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.layer.borderColor = UIColor.clear.cgColor
        self.setAttributedTitle(nil, for: UIControlState.normal)
    }
}

extension ViewController{
    
    func cardToString(from card : Card) -> NSAttributedString{
        var strokeTextAttributes : [NSAttributedStringKey:Any] = [NSAttributedStringKey:Any]()
        var manipulatedValue : String = ""
        
        for _ in 0..<card.number.rawValue{
            manipulatedValue.append(card.shape.rawValue)
        }
        
        switch(card.color){
        case .Blue:
            strokeTextAttributes[.strokeColor] = UIColor.blue
            strokeTextAttributes[.foregroundColor] = UIColor.blue
        case .Green:
            strokeTextAttributes[.strokeColor] = UIColor.green
            strokeTextAttributes[.foregroundColor] = UIColor.green
        case .Red:
            strokeTextAttributes[.strokeColor] = UIColor.red
            strokeTextAttributes[.foregroundColor] = UIColor.red
        default:
            break
        }
        
        switch(card.shading){
        case .Solid:
            strokeTextAttributes[.strokeWidth] = -2
        case .Outlined:
            strokeTextAttributes[.strokeWidth] = 10
            strokeTextAttributes[.strokeColor] = (strokeTextAttributes[.strokeColor] as! UIColor).withAlphaComponent(1.0)
            strokeTextAttributes[.foregroundColor] = (strokeTextAttributes[.strokeColor] as! UIColor).withAlphaComponent(1.0)
        case .Striped:
            strokeTextAttributes[.strokeWidth] = -1
            strokeTextAttributes[.strokeColor] = (strokeTextAttributes[.strokeColor] as! UIColor).withAlphaComponent(0.35)
            strokeTextAttributes[.foregroundColor] = (strokeTextAttributes[.strokeColor] as! UIColor).withAlphaComponent(0.35)
        default:
            strokeTextAttributes[.strokeWidth] = 0
        }
        
        return NSAttributedString(string: manipulatedValue, attributes: strokeTextAttributes)
        

    }
    
}


