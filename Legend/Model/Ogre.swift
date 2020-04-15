//
//  Enemy.swift
//  Legend
//
//  Created by Daniel Castro on 4/2/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//
import UIKit
class Ogre : Enemy{
    var name: String = "Ogre"
    var strRequirement: Int = 5
    var agiRequirement: Int = 5
    var defaultPicString: String = "ogre_idle_f0"
    var health: Int = 120
    
    func idleAnimation() -> [UIImage] {
        
        let imageNames = ["ogre_idle_f0", "ogre_idle_f1", "ogre_idle_f2", "ogre_idle_f3"]
        var images = [UIImage]()
        
        for i in 0..<imageNames.count {
            images.append(UIImage(named: imageNames[i])!)
        }
        
        return images
    }
    
    func takeDamage(damage: Int) {
        health -= damage
    }
    
    func attack() -> Int {
        return 50
    }
}
