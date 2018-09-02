// Test Again
// Test
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

class SetViewController: UIViewController {
    private var grid : Grid = Grid(layout: Grid.Layout.aspectRatio(1))
    private var game : Set = Set()
    private var startGame : Bool = false
    @IBOutlet weak var GridView: UIView!
    @IBOutlet weak var DiscardView: UIView!
    @IBOutlet weak var DeckView: UIView!
    
    
    
    @IBAction func startGame(_ sender: UIButton) {
        game = Set()
        resetView()
        updateViewFromModel()
        startGame = true
        
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
        if startGame{
            updateViewFromModel()
        }
        
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
            if game.cards.count < game.maxCards{
                discard.isEmpty = false
            } else{
                discard.isEmpty = true
            }
        }
    }
    
    private func drawCards(for views : [UIView] , with viewCount : Int){
        grid.cellCount = game.cardsInPlay.count
        
        if views.count > game.cardsInPlay.count{
            
            for index in 0..<viewCount{
                self.removeCards(at: index)
                let debouncedFunction = Debouncer(delay: index.interval()) {
                }
                self.resizeAndPlaceCard(at: index)
                debouncedFunction.call()
                
            }
            
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
        }else{
            for index in 0..<game.cardsInPlay.count{
                self.resizeAndPlaceCard(at: index)
                self.checkHighlight(at: index)
            }
        }
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
                
                
                
                self.GridView.addSubview(customView)
                self.resize(from: customView, to: cellView, delay: time )
                self.move(this: customView, fromPositionOf: self.DeckView,
                          toPositionOf : customView , delay : time){
                            self.flipCard(view: customView , delay : time)
                            customView.addGestureRecognizer(tap)
                            
                }
               
                
                
                
                
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(swipeDown(_:)))
        DeckView.addGestureRecognizer(tap)
    }
    
    private func addRotate(){
        let twist = UIRotationGestureRecognizer(target: self, action: #selector(self.rotate(_:)))
        self.view.addGestureRecognizer(twist)
    }
    
    @objc func swipeDown(_ sender: UITapGestureRecognizer){
        switch sender.state{
        case .ended:
            game.addCards()
            updateViewFromModel()
        default : break
        }
        
        
        
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
    
    
    
    
    
}


extension Int {
    func interval() -> Double {
        return Double ( (self + 1) )/4
    }
}
