//
//  SelectCharacterViewController.swift
//  Legend
//
//  Created by Daniel Castro on 4/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import Firebase
import UIKit

class SelectCharacterViewController: UIViewController {
    
    @IBOutlet weak var maleImageView: UIImageView!
    @IBOutlet weak var femaleImageView: UIImageView!
    @IBOutlet weak var beginButton: UIButton!
    var selectedImage: UIImageView?
    
    var newUserData: [String:Any]?
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        // Set nav bar color
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.7070196639, green: 0.7053460761, blue: 0.7092124048, alpha: 0)
        // Button rounded corners
        beginButton.layer.cornerRadius = 25
    }
    
    @IBAction func beginAdventureButtonPressed(_ sender: UIButton) {
        if var userData = newUserData, let activeImage = selectedImage {
            let gender = (activeImage == maleImageView ? "Male": "Female")
            userData["character"] = [
                "equipped": [],
                "gender": gender
            ]
            db.collection("userData").addDocument(data: userData) { (error) in
                if let e = error {
                    print("There was an issue saving user data to Firestore: \(e)")
                } else {
                    print("Succesfully saved data!")
                    self.performSegue(withIdentifier: "registerToHome", sender: self)
                }
            }
        }
    }
    
    @IBAction func maleImageTapped(_ sender: Any) {
        showAnimation(imageView: maleImageView)
    }
    
    @IBAction func femaleImageTapped(_ sender: Any) {
        showAnimation(imageView: femaleImageView)
    }
    
    func showAnimation(imageView: UIImageView) {
        stopPreviousAnimation(imageView)
        let gender = (imageView == maleImageView ? "m_elf" : "f_elf")
        let playerModel = Player(playerType: gender)
        
        imageView.animationImages = playerModel.idleAnimation()
        imageView.animationDuration = 0.5
        imageView.startAnimating()
    }
    
    func stopPreviousAnimation(_ imageView: UIImageView) {
        if let currentImage = selectedImage {
            if currentImage != imageView {
                currentImage.stopAnimating()
            }
        }
    }
    
}
