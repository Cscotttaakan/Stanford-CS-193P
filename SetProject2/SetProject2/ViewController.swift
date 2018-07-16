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
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func TouchCard(_ sender: UIButton) {
        
        if let cardNumber = cardButtons.index(of: sender){
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
        for index in 0..<game.cardsInPlay.count{
            cardButtons[index].draw(string: game.cardsInPlay[index]?.rawValue())
        }
    }
    
    private func drawHighlighted(){
        for key in game.cardsHighlighted.keys{
            cardButtons[key].drawHighlighted(string: game.cardsInPlay[key]?.rawValue())
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
            time = 0
            if(game.findSet()){
 

                game.competitor.state = .Win
                game.removeSet()
                game.wonRound = false
                game.Score -= 2
                
            }
            else{
                game.addCards()
                
                print("No set in cards")
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
    
    func drawHighlighted(string : NSAttributedString?){
        self.layer.borderColor = UIColor.blue.cgColor
        self.setAttributedTitle(string,for: UIControlState.normal)
    }
    
    func remove(){
        self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        self.layer.borderColor = UIColor.clear.cgColor
        self.setAttributedTitle(nil, for: UIControlState.normal)
    }
}


