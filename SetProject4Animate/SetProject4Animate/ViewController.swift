
//
//  ViewController.swift
//  SetProject2
//
//  Created by Craig Scott on 7/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

struct Constants{
    static var flipTime : Double = 0.5
    static var translateTime : Double = 0.5
    static var origin : CGPoint = CGPoint( x : 0 , y : 0)
    
    
}

class ViewController: UIViewController {
    private var grid : Grid = Grid(layout: Grid.Layout.aspectRatio(1))
    private var game : Set = Set()
    @IBOutlet weak var GridView: UIView!
    @IBOutlet weak var DiscardView: UIView!
    @IBOutlet weak var DeckView: UIView!
    
    
    
    @IBAction func startGame(_ sender: UIButton) {
        updateViewFromModel()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let discard = DiscardView as? DeckView{
            discard.isEmpty = true
        }
        
        addSwipe()
        addRotate()
    }
    
    
    
    
    
    override func viewDidLayoutSubviews() {
        //if startGame{
        updateViewFromModel()
        //  }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func recalculate(){
        //resetView()
        
        grid = Grid(layout: Grid.Layout.aspectRatio(3 / 4), frame: CGRect(x: GridView.layoutMargins.right / 2, y: GridView.layoutMargins.top,width: GridView.frame.width, height: GridView.frame.height))
        
        
    }
    
    func resetView(){
        if GridView.subviews.count > 0{
            GridView.subviews.forEach {
                $0.removeFromSuperview()
                
            }
        }
    }
    
    @IBOutlet weak var Score: UILabel!
    
    @IBAction func addCards(_ sender: UIButton) {
        //resetOnGoingGame()
        game.addCards()
        updateViewFromModel()
    }
    
    
    
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var computerState: UILabel!
    
    
    private func updateViewFromModel(){
        
        
        let views : [UIView] = GridView.subviews
        let viewCount = GridView.subviews.count
        //resetView()
        recalculate()
        drawCards(for : views , with : viewCount)
        
        
        drawDeck()
        
        //To see how many cards are in view before we readd
        
        
        
    }
    
    private func drawDeck(){
        if let deck = (DeckView as? DeckView){
        if game.cards.count > 0{
            deck.isEmpty = false
        }
        else{
            deck.isEmpty = true
        }
        }
    }
    
    private func drawDiscard(){
        if let discard = (DiscardView as? DeckView){
        discard.isEmpty = false
        }
    }
    
    private func drawCards(for views : [UIView] , with viewCount : Int){
        grid.cellCount = game.cardsInPlay.count
        //self.view.layoutIfNeeded()
        //We are adding/removing/resizing
        
        
        
        //Using start cards to check if need to add more cards or remove based on buffer between view and model
        
        if views.count > game.cardsInPlay.count{
            
            for index in 0..<viewCount{
                self.removeCards(at: index)
                let debouncedFunction = Debouncer(delay: index.interval()) {
                    
                self.resizeAndPlaceCard(at: index)
                }
                debouncedFunction.call()
                
                /*for index in removeList{
                    self.GridView.subviews[index].removeFromSuperview()
                } */
                
            }
            
            
            
            
            /*for index in removeList{
                self.GridView.subviews[index].removeFromSuperview()
            }*/
                
        }else if views.count < game.cardsInPlay.count{
            for index in 0..<game.cardsInPlay.count{
                let debouncedFunction = Debouncer(delay: index.interval()) {
                    if index < self.GridView.subviews.count{
                        self.resizeAndPlaceCard(at: index)
                }else{
                        self.addCard(at : index)
                }
            }
                debouncedFunction.call()
                
            }
            
            
            
            
            //addCards()
            //updateView()
        }else{
            for index in 0..<game.cardsInPlay.count{
                self.resizeAndPlaceCard(at: index)
                self.checkHighlight(at: index)
            }
        }
        
        
        //updateView()
        
        
        
        
    }
    
    func cardExists(card : CardView) -> Int?{
        for index in 0..<game.cardsInPlay.count{
            if (card.color == game.cardsInPlay[index].color) && (card.shape == game.cardsInPlay[index].shape) && (card.number == game.cardsInPlay[index].number) && (card.shading == game.cardsInPlay[index].shading){
                return index
            }
        }
        return nil
    }
    
    // MARK: Need to defragment into to pieces
    // TO-DO: Index at 0
    
    func removeCards(at index : Int){
    if let view = self.GridView.subviews[index] as? CardView ,  cardExists( card : view) == nil{
        (self.GridView.subviews[index] as? CardView)?.regularBorder()
        self.flipCard(view: self.GridView.subviews[index], delay: index.interval())
        self.move(this: self.GridView.subviews[index], fromPositionOf: self.GridView.subviews[index], toPositionOf: self.DiscardView, delay: index.interval() ){
            self.GridView.subviews[index].removeFromSuperview()
            self.drawDiscard()
            
    }
        self.resize(from: self.GridView.subviews[index], to: self.DiscardView, delay: 0)
    }
    }
    
    func resizeAndPlaceCard( at index : Int){
        let time = index.interval()
        if index < GridView.subviews.count{
            if self.GridView.subviews.count > 0, index < self.GridView.subviews.count,  let view = self.GridView.subviews[index] as? CardView , let index = self.cardExists(card: view){
                //self.GridView.addSubview(view)
                if let cellView : UIView = self.grid[index]{
                    let customView = CardView(frame : cellView.frame)
                    customView.isHidden = true
                    GridView.addSubview(customView)
                    
                    self.move(this : view , fromPositionOf: view, toPositionOf: customView , delay : time){}
                    
                    self.resize(from : view, to: customView , delay : 0)
                    GridView.subviews[GridView.subviews.count - 1].removeFromSuperview()
                    
                    
                }
                
                
            }
            }
        }
        
        
        
        
        
    
    
    func addCard(at index : Int){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        let time = index.interval()
        if index < game.cardsInPlay.count{
        let card = game.cardsInPlay[index]
        if let cellView : UIView = grid[index]{
            let customView = CardView(frame : cellView.frame, shape : card.shape, color : card.color, number : card.number, shading: card.shading)
            
            
                /*if self.GridView.subviews.count > 0, index < self.GridView.subviews.count,  let view = self.GridView.subviews[index] as? CardView , self.cardExists(card: view){
                 //self.GridView.addSubview(view)
                 
                 
                 self.move(this : view , fromPositionOf: view, toPositionOf: customView , delay : time){}
                 self.resize(from : view, to: customView , delay : 0)
                 }else{*/
                
                
                
                self.GridView.addSubview(customView)
                self.move(this: customView, fromPositionOf: self.DeckView,
                          toPositionOf : customView , delay : time){
                            
                            self.flipCard(view: customView , delay : time)
                            customView.addGestureRecognizer(tap)
                }
                
                
                
                //}
            
            
        }
        }
    }
    
    
    
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer){
        if(gestureRecognizer.state == .ended){
            game.reshuffle()
            updateViewFromModel()
        }
        
    }
    
    @objc func tap(_ sender: UITapGestureRecognizer){
        switch sender.state{
        case .ended:
            if let cardView = sender.view as? CardView{
                
                if cardView.isFaceUp{
                    for cardNumber in 0..<GridView.subviews.count{
                        if cardView == GridView.subviews[cardNumber]{
                            game.chooseCard(index: cardNumber)
                        }
                    }
                    
                    self.updateViewFromModel()
                }
                else{
                }
            }
            
        default : break
        }
    }
    
    private func addSwipe(){
        let gesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        gesture.direction = .down
        self.view.addGestureRecognizer(gesture)
    }
    
    private func addRotate(){
        let twist = UIRotationGestureRecognizer(target: self, action: #selector(self.rotate(_:)))
        self.view.addGestureRecognizer(twist)
    }
    
    @objc func swipeDown(_ sender: UITapGestureRecognizer){
        
        
        
        game.addCards()
        updateViewFromModel()
        
        
    }
    // MARK: Index out of range due to clearing cards before redrawing, need to implement within draw cards.
    //Checks the model cards and reflects it in the CardView
    private func checkHighlight(at index : Int){
        if GridView.subviews.count > 0 && index < GridView.subviews.count{
            if game.cardsHighlighted[index] != nil{
                (GridView.subviews[index] as? CardView)?.highlightBorder()
            }
            else{
                (GridView.subviews[index] as? CardView)?.regularBorder()
            }
        }
        
    }
    
    private func removeCardsNotInPlay(){
        /*for index in 0..<cardButtons.count{
         if !game.cardsInPlay.keys.contains(index){
         cardButtons[index].remove()
         }
         }*/
    }
    /*
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
     } */
    
    
    
}


extension Int {
    func interval() -> Double {
        return Double ( (self + 1) )/4
    }
}
