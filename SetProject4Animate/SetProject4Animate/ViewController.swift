//
//  ViewController.swift
//  SetProject2
//
//  Created by Craig Scott on 7/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

struct Constants{
    static var flipTime : Double = 1
    static var translateTime : Double = 1
    static var origin : CGPoint = CGPoint( x : 0 , y : 0)
    
    
}

class ViewController: UIViewController {
    private var grid : Grid = Grid(layout: Grid.Layout.aspectRatio(1))
    private var game : Set = Set()
    //private var isTimerRunning = false
    //private var time = 0
    //private var timer = Timer()
    //private var deal : Bool = true
    //private var startGame : Bool = false
    //private var startCards : Int = 0
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
        //updateViewFromModel()
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
    
    /*
     func resetOnGoingGame(){
     updateViewFromModel()
     time = 0
     game.clearHighlight()
     } */
    
    @IBOutlet var cardButtons: [UIButton]!
    
    
    
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var computerState: UILabel!
    
    
    private func updateViewFromModel(){
        
        
        let views : [UIView] = GridView.subviews
        
        resetView()
        recalculate()
        drawCards(for : views)
        
        
        drawDeck()
        drawDiscard()
        
        //To see how many cards are in view before we readd
        
        
        
    }
    
    private func drawDeck(){
        if game.cards.count > 0{
            
        }
    }
    
    private func drawDiscard(){
        
    }
    
    private func drawCards(for views : [UIView]){
        grid.cellCount = game.cardsInPlay.count
        self.view.layoutIfNeeded()
        //We are adding/removing/resizing
        
        
        //Using start cards to check if we need to add more cards or remove based on buffer between view and model
        
        if views.count > game.cardsInPlay.count{
            //removeCards()
            //updateView()
        }else if views.count <= game.cardsInPlay.count{
            for index in 0..<game.cardsInPlay.count{
                addCard(at: index, with : views)
                checkHighlight(at: index , for : views)
                
                print(index)
            }
            
            //addCards()
            //updateView()
        }
        
        
        //updateView()
        
        
        
        
    }
    
    func cardExists(card : CardView) -> Bool{
        for check in game.cardsInPlay{
            if (card.color == check.color) && (card.shape == check.shape) && (card.number == check.number) && (card.shading == check.shading){
                return true
            }
        }
        return false
    }
    
    // MARK: Need to defragment into to pieces
    // TO-DO: Index at 0
    
    func addCard(at index : Int , with array : [UIView]){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        let time = index.interval()
        let card = game.cardsInPlay[index]
        if let cellView : UIView = grid[index]{
            let customView = CardView(frame : cellView.frame, shape : card.shape, color : card.color, number : card.number, shading: card.shading)
            customView.addGestureRecognizer(tap)

            if array.count > 0, index < array.count,  let view = array[index] as? CardView , cardExists(card: view){
                self.GridView.addSubview(view)
                let debouncedFunction = Debouncer(delay: time) {
                    
                    self.move(this : view , fromPositionOf: view, toPositionOf: customView , delay : time){
                        self.resize(from : view, to: customView , delay : time)
                    }
                }
                debouncedFunction.call()
            }else{
                
                
                let debouncedFunction = Debouncer(delay : time){
                    self.GridView.addSubview(customView)
                    self.move(this: customView, fromPositionOf: self.DeckView,
                              toPositionOf : customView , delay : time){
                                
                                self.flipCard(view: customView , delay : time)
                    }
                    
                    
                }
                debouncedFunction.call()
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
    private func checkHighlight(at index : Int , for cards : [UIView]){
        if cards.count > 0 && index < cards.count{
            if game.cardsHighlighted[index] != nil{
                (cards[index] as? CardView)?.highlightBorder()
            }
            else{
                (cards[index] as? CardView)?.regularBorder()
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
