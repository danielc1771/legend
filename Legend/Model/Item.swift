//
//  Enemy.swift
//  Legend
//
//  Created by Daniel Castro on 4/2/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//
import UIKit
class Item {
    func chestAnimation() -> [UIImage] {
        let imageNames = ["chest_full_f0", "chest_full_f1", "chest_full_f2"]
        var images = [UIImage]()
        
        for i in 0..<imageNames.count {
            images.append(UIImage(named: imageNames[i])!)
        }
        return images
    }
    
    func emptyChestAnimation() -> [UIImage] {
        let imageNames = ["chest_empty_f0", "chest_empty_f1", "chest_empty_f2"]
        var images = [UIImage]()
        
        for i in 0..<imageNames.count {
            images.append(UIImage(named: imageNames[i])!)
        }
        return images
        
    }
}
