//
//  ViewController.swift
//  SetProject2
//
//  Created by Craig Scott on 7/2/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    private var gridView : Grid = Grid(layout: Grid.Layout.aspectRatio(1))
    private var game : Set = Set()
    private var isTimerRunning = false
    private var time = 0
    private var timer = Timer()
    private var cards : [CardView] = [CardView]()
    private var dealCards : Bool = true
    private var startGame : Bool = false
    @IBOutlet weak var GridView: UIView!
    @IBOutlet weak var DiscardView: UIView!
    @IBOutlet weak var DeckView: UIView!
    
    
    
    @IBAction func startGame(_ sender: UIButton) {
        recalculate()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // initialize button styles
        /*
         for index in 0..<cardButtons.count{
         cardButtons[index].layer.borderWidth = 3.0
         cardButtons[index].layer.cornerRadius = 8.0
         cardButtons[index].tintColor = UIColor.clear
         cardButtons[index].remove()
         }*/
        
        /* gridView.cellCount = game.maxCards
         for index in 0..<gridView.cellCount{
         
         let customView : CardView = CardView(frame: gridView[index]!, shape: .Circle, color: .Blue, number: .One, shading: .Striped)
         self.view.addSubview(customView)
         } */
        if let discard = DiscardView as? DeckView{
            discard.isEmpty = true
        }
        
        addSwipe()
        addRotate()
    }
    
    
//    override func viewDidLayoutSubviews() {
//        if startGame{
//            recalculate()
//        }
//    }
    
    
    override func viewDidLayoutSubviews() {
        if startGame{
        recalculate()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    private func recalculate(){
        resetView()
        
        gridView = Grid(layout: Grid.Layout.aspectRatio(3 / 4), frame: CGRect(x: GridView.layoutMargins.right / 2, y: GridView.layoutMargins.top,width: GridView.frame.width, height: GridView.frame.height ))
        
        updateViewFromModel()
    }
    
    func resetView(){
        cards.removeAll()
        if GridView.subviews.count > 0{
            GridView.subviews.forEach {
                $0.removeFromSuperview()
                
            }
        }
    }
    
    private func dealThreeCards(){
        
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
    
    
    
    @IBOutlet weak var gameTime: UILabel!
    @IBOutlet weak var computerState: UILabel!
    
    
    private func updateViewFromModel(){
        resetView()
        drawCards()
        drawDeck()
        drawDiscard()
        //drawHighlighted()
        //removeCardsNotInPlay()
        //Score.text = "Score: \(game.Score)"
        
        
    }
    
    private func drawDeck(){
        if game.cards.count > 0{
            
        }
    }
    
    private func drawDiscard(){
        
    }
    
 
    @objc
    private func drawCards(){
        gridView.cellCount = game.cardsInPlay.count
        /*var index = 0
         for tuple in game.cardsInPlay{
         if let frame = gridView[index]{
         let card = tuple.value
         let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
         let customView : CardView = CardView(frame: frame, shape: card.shape, color: card.color, number: card.number, shading: card.shading)
         if game.cardsHighlighted[index] != nil{
         customView.highlightBorder()
         }
         else{
         customView.regularBorder()
         }
         customView.addGestureRecognizer(tap)
         GridView.addSubview(customView)
         cards.append(customView)
         
         }
         
         index += 1
         }*/
        
        let index = 0
        //for index in 0..<game.cardsInPlay.count{
            
            if let frame : CGRect = gridView[index]{
                let card = game.cardsInPlay[index]
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
                
                let customView : CardView = CardView(frame: frame, shape: card.shape, color: card.color, number: card.number, shading: card.shading)
                
                
                
                
                
                if game.cardsHighlighted[index] != nil{
                    customView.highlightBorder()
                }
                else{
                    customView.regularBorder()
                }
                customView.addGestureRecognizer(tap)
                
                GridView.addSubview(customView)
                
                cards.append(customView)
                
                
                if dealCards{

                    UIView.transition(with: GridView.subviews[0],
                                      duration: 2.0,
                                      options: [.transitionFlipFromLeft],
                                      animations: {
                                        let debouncedFunction = Debouncer(delay: 2.0){
                                        (self.GridView.subviews[0] as? CardView)?.isFaceUp = true
                                        }
                                        debouncedFunction.call()
                    } )


                }
                
            //}
            
            
            
        }
        
        //dealCards = false
        
        if let card = gridView[0]{
        let deckView : CardView = CardView(frame : card , shape: Shape.none, color : Color.none, number : Number.none, shading: Shading.none)
            }
        
        //dealCards = false
    }
    
    
    
    
    
    @objc func rotate(_ gestureRecognizer: UIRotationGestureRecognizer){
        /*if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
         gestureRecognizer.view?.transform = gestureRecognizer.view!.transform.rotated(by: gestureRecognizer.rotation)
         gestureRecognizer.rotation = 0
         }*/
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
            for cardNumber in 0..<cards.count{
                if cardView == cards[cardNumber]{
                    
                    game.chooseCard(index: cardNumber)
                    
                    
                }
            }
            
                self.updateViewFromModel()
            }
            else{
//                UIView.transition(with: cardView,
//                                  duration: 3.0,
//                                  options: [UIViewAnimationOptions.transitionFlipFromLeft],
//                                  animations: {
//                                    cardView.isFaceUp = true
//
//                }, completion : { _ in
//                }
//                )
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
    
    private func drawHighlighted(){
        for key in game.cardsHighlighted.keys{
            
            
            
        }
    }
    
    private func removeCardsNotInPlay(){
        /*for index in 0..<cardButtons.count{
         if !game.cardsInPlay.keys.contains(index){
         cardButtons[index].remove()
         }
         }*/
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
/* extension UIButton{
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
 */



