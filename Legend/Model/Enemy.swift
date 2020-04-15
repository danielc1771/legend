//
//  Enemy.swift
//  Legend
//
//  Created by Daniel Castro on 4/6/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

protocol Enemy {
    var name: String { get }
    var strRequirement: Int { get }
    var agiRequirement: Int { get }
    var defaultPicString: String { get }
    var health: Int { get }
    
    func idleAnimation() -> [UIImage]
    func takeDamage(damage: Int)
    func attack() -> Int
}
