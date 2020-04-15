//
//  HomeViewController.swift
//  Legend
//
//  Created by Daniel Castro on 2/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    let db = Firestore.firestore()
    var user: User?
    var userPlayer: Player?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var strLabel: UILabel!
    @IBOutlet weak var agiLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        getUserData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func trainStrengthPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToStrength", sender: self)
    }
    
    @IBAction func trainAgilityPressed(_ sender: Any) {
        performSegue(withIdentifier: "homeToAgility", sender: self)
    }
    
    func getUserData() {
        if let email = Auth.auth().currentUser?.email {
            db.collection("userData")
                .whereField("email", isEqualTo: email)
                .getDocuments()
                    { (querySnapshot, error) in
                        
                        if let e = error {
                            print("There was an issue retrieving data from Firestore. \(e)")
                        } else {
                            if let snapshotDocuments = querySnapshot?.documents {
                                for doc in snapshotDocuments {
                                    let userId = doc.documentID
                                    let data = doc.data()
                                    if let firstName = data["firstName"] as? String, let lastName = data["lastName"] as? String,
                                        let birthDate = data["birthDate"] as? String, let creationDate = data["creationDate"] as? Double,
                                        let email = data["email"] as? String, let character = data["character"] as? [String: Any], let strengthXP = data["strengthXP"] as? Int, let agilityXP = data["agilityXP"] as? Int {
                                        
                                        DispatchQueue.main.async {
                                            let userData = User(firstName: firstName, lastName: lastName, birthDate: birthDate, creationDate: creationDate, email: email, character: character, strengthXP: strengthXP, agilityXP: agilityXP, id: userId)
                                            self.user = userData
                                            self.displayUserData()
                                            self.displayUserStats()
                                            self.displayUserImage()
                                            self.setChallengeData()
                                        }
                                    }
                                }
                            }
                        }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToAgility" {
            let vc = segue.destination as! AgilityViewController
            vc.user = user
        }
    }
    
    func setChallengeData() {
        let vc = tabBarController?.viewControllers![0] as! ChallengeSelectViewController
        vc.user = user
        vc.player = userPlayer
    }
    
    func displayUserData() {
        if let name = self.user?.firstName {
            userNameLabel.text = name
        }
    }
    
    func displayUserStats() {
        if let strengthLevel = self.user?.strengthLevel, let agilityLevel = self.user?.agilityLevel {
            strLabel.text = "\(strengthLevel)"
            agiLabel.text = "\(agilityLevel)"
        }
    }
    
    func displayUserImage() {
        if let playerType = user?.getUserImage() {
            userPlayer = Player(playerType: playerType)
            userImageView.animationImages = userPlayer?.idleAnimation()
            userImageView.animationDuration = 0.5
            userImageView.startAnimating()
        }
    }
    
}
