//
//  ViewController.swift
//  PlayingCard
//
//  Created by Craig Scott on 6/29/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var deck: PlayingCardDeck = PlayingCardDeck()
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    
    lazy var cardBehavior : CardBehavior = CardBehavior(in: animator)
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    private var faceUpCardViews : [PlayingCardView] {
        return cardViews.filter {$0.isFaceUp && !$0.isHidden }
    }
    
    private var faceUpCardViewsMatch : Bool  {
        return faceUpCardViews.count == 2 &&
            faceUpCardViews[0].rank == faceUpCardViews[1].rank &&
            faceUpCardViews[0].suit == faceUpCardViews[1].suit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var cards = [PlayingCard]()
        
        for _ in 1...((cardViews.count + 1) / 2){
            let card = deck.draw()!
            cards += [card, card]
        }
        
        for cardView in cardViews{
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4Random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)
            
        }
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer){
        switch recognizer.state{
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView{
                //If you remove this, it prevents the cards from increasing in size & teleporting
                //If it is here, the cards teleport and increase in size
                self.cardBehavior.removeItem(chosenCardView)
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: [.transitionFlipFromLeft],
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                                  completion: { finished in
                                    
                                    if self.faceUpCardViewsMatch{
                                        UIViewPropertyAnimator.runningPropertyAnimator(
                                            withDuration: 0.6,
                                            delay: 0,
                                            options: [],
                                            animations: {
                                                self.faceUpCardViews.forEach {
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                                }
                                        }
                                            ,completion: { position in
                                                UIViewPropertyAnimator.runningPropertyAnimator(
                                                    withDuration: 0.75 ,
                                                    delay: 0,
                                                    options: [],
                                                    animations: {
                                                        self.faceUpCardViews.forEach {
                                                            $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                            $0.alpha = 0
                                                        }
                                                }
                                                    /*,completion: { position in
                                                        self.faceUpCardViews.forEach{
                                                            $0.isHidden = true
                                                            $0.alpha = 1
                                                            $0.transform = .identity
                                                        }
                                                }*/
                                                )
                                        }
                                        )
                                        
                                    } else if self.faceUpCardViews.count >= 2{
                                        self.faceUpCardViews.forEach { cardView in
                                            UIView.transition(with: cardView,
                                                              duration: 0.6,
                                                              options: [.transitionFlipFromLeft],
                                                              animations: {
                                                                cardView.isFaceUp = false
                                            },
                                                              completion: { finished in
                                                                self.cardBehavior.addItem(cardView)
                                            }
                                            )
                                        }
                                    }
                                    else{
                                        if !chosenCardView.isFaceUp{
                                            self.cardBehavior.addItem(chosenCardView)
                                        }
                                    }
                }
                )
                
            }
        default:
            break
        }
    }
    
    
}


extension CGFloat{
    var arc4Random: CGFloat{
        if self > 0{
            return CGFloat(arc4random_uniform(UInt32(self)))
        }
        else if self < 0{
            return -CGFloat(arc4random_uniform(UInt32(self)))
        }
        else{
            return 0
        }
    }
}
