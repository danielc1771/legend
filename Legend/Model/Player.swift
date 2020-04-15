//
//  Enemy.swift
//  Legend
//
//  Created by Daniel Castro on 4/2/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//
import UIKit
class Player {
    var health: Int = 100
    var dodgedNextAttack: Bool = false
    var playerImages: [String]
    
    init(playerType: String) {
        let possibleImages = [
            "m_elf": ["elf_m_idle_f0", "elf_m_idle_f1", "elf_m_idle_f2", "elf_m_idle_f3"],
            "f_elf": ["elf_f_idle_f0", "elf_f_idle_f1", "elf_f_idle_f2", "elf_f_idle_f3"],
            "armored_elf": ["knight_idle_f0", "knight_idle_f1", "knight_idle_f2", "knight_idle_f3"],
            "knight_m_run": ["knight_m_run_f0", "knight_m_run_f1", "knight_m_run_f2", "knight_m_run_f3"]
        ]
        
        playerImages = possibleImages[playerType]!
    }
    
    func idleAnimation() -> [UIImage] {
        var images = [UIImage]()
        
        for i in 0..<playerImages.count {
            images.append(UIImage(named: playerImages[i])!)
        }
        return images
    }
    
    func takeDamage(damage: Int) {
        health -= damage
    }
    
    func setDodgeNextAttack(_ dodgeStatus: Bool) {
        dodgedNextAttack = dodgeStatus
    }
}


