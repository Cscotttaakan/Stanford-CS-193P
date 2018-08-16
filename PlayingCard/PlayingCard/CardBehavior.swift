//
//  CardBehavior.swift
//  PlayingCard
//
//  Created by Craig Scott on 8/15/18.
//  Copyright © 2018 Craig Scott. All rights reserved.
//

import UIKit

class CardBehavior: UIDynamicBehavior {
    
    
    
    lazy var collisionBehavior: UICollisionBehavior = {
        let behavior = UICollisionBehavior()
        behavior.translatesReferenceBoundsIntoBoundary = true
        return behavior
        
    }()
    
    lazy var itemBehavior : UIDynamicItemBehavior = {
        let behavior = UIDynamicItemBehavior()
        behavior.allowsRotation = false
        behavior.elasticity = 1.0
        behavior.resistance = 0
        return behavior
    }()
    
    private func push(_ item : UIDynamicItem){
        let push = UIPushBehavior(items: [item], mode: .instantaneous)
        push.angle = (2 * CGFloat.pi).arc4Random
        push.magnitude = 1.0 + CGFloat(2.0).arc4Random
        push.action = { [unowned push, weak self] in
            self?.removeChildBehavior(push)
        }
        addChildBehavior(push)
    }
    
    func addItem( _ item : UIDynamicItem){
        collisionBehavior.addItem(item)
        itemBehavior.addItem(item)
        push(item)
    } 
    
    func removeItem( _ item : UIDynamicItem){
        collisionBehavior.removeItem(item)
        itemBehavior.removeItem(item) 
    }
    
    override init(){
        super.init()
        addChildBehavior(itemBehavior)
        addChildBehavior(collisionBehavior)
        
    }
    
    convenience init( in animator : UIDynamicAnimator){
        self.init()
        animator.addBehavior(self)
    }

}
