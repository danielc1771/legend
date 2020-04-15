//
//  VictoryViewController.swift
//  Legend
//
//  Created by Daniel Castro on 4/6/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class VictoryViewController: UIViewController {
    let db = Firestore.firestore()
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var unlockTextLabel: UILabel!
    @IBOutlet weak var equipButton: UIButton!
    
    var user: User?
    var armor: Armor = Armor()
    
    override func viewDidLoad() {
        if !userHasItem(item: "armor") {
            updateUserItems(item: "armor")
            itemImageView.animationImages = armor.chestAnimation()
            itemImageView.animationDuration = 1.5
            itemImageView.animationRepeatCount = 1
            itemImageView.startAnimating()
            itemImageView.image = UIImage(named: "knight_idle_f0")
            unlockTextLabel.text! += "\n Armor Set"
            updateUserItems(item: "armor")
        } else {
            itemImageView.animationImages = armor.emptyChestAnimation()
            itemImageView.animationDuration = 1.5
            itemImageView.animationRepeatCount = 1
            itemImageView.startAnimating()
            equipButton.setTitle("Exit", for: .normal)
            unlockTextLabel.text! = "You've already looted this item!"
        }
    }
    
    @IBAction func equipButtonPressed(_ sender: Any) {
        let vcs = navigationController?.viewControllers
        let tabBar = vcs![vcs!.count - 3] as! TabBarController
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: false)
        tabBar.selectedIndex = 1
    }
    
    func userHasItem(item: String) -> Bool {
        return (user?.equippedItems.contains(item))!
    }
    
    func updateUserItems(item: String) {
        if let userId = user?.id {
            let gender = user?.gender
            var equippedItems = user?.equippedItems
            equippedItems?.append(item)
            let userRef = db.collection("userData").document(userId)
            userRef.updateData([
                "character": [
                    "gender": gender!,
                    "equipped": equippedItems!
                ]
            ]) { err in
            if let err = err {
                print("Error updating user items: \(err)")
            } else {
                print("User items successfully updated")
            }
            }
        }
    }
}
