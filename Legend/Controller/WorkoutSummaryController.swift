//
//  WorkoutSummaryController.swift
//  Legend
//
//  Created by Daniel Castro on 3/14/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//
import Firebase
import UIKit

class WorkoutSummaryController: UIViewController {
    let db = Firestore.firestore()
     
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var totalWeightLabel: UILabel!
    @IBOutlet weak var expLabel: UILabel!
    
    var totalTime: String = ""
    var totalWeight: Int = 0
    var totalTimeInSecs: Int = 0
    var totalReps: Int = 0
    var expGained: Int = 0
    var user: User?
    
    
    var workoutStats: [String: [[String: Int]]] = [:]
    
    override func viewDidLoad() {
        getUserData()
        calculateTotalWeight()
        calculateXP()
        totalWeightLabel.text! += " \(totalWeight)"
        totalTimeLabel.text! += " \(totalTime)"
        expLabel.text! += " \(expGained)XP"
        storeWorkoutData()
    }
    
    
    func calculateTotalWeight() {
        for exercise in workoutStats {
            for set in exercise.value {
                if let reps = set["reps"], let weight = set["weight"] {
                    totalReps += reps
                    totalWeight += reps * weight
                }
            }
        }
    }
    
    func calculateXP() {
        expGained = Int(sqrt(Double(totalReps)) + Double((totalTimeInSecs / 75)))
        updateUserStrengthXP()
    }
    
    func updateUserStrengthXP() {
        if let userId = user?.id {
            let userRef = db.collection("userData").document(userId)
            
            userRef.updateData([
                "strengthXP": user!.strengthXP + expGained
            ]) { err in
            if let err = err {
                print("Error updating user strengthXP: \(err)")
            } else {
                print("User strengthXP successfully updated")
            }
            }
        }
    }
    
    func getUserData() {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        let tabVC = viewControllers[2] as! TabBarController
        let homeVC = tabVC.children[1] as! HomeViewController
        user = homeVC.user
    }
    
    func storeWorkoutData() {
        if let email = Auth.auth().currentUser?.email {
            db.collection("workoutHistory").addDocument(data: [
                "user": email,
                "date": Date().timeIntervalSince1970,
                "duration": totalTime,
                "workout": workoutStats,
                "expGained": expGained,
                "type": "STR"
            ]) { (error) in
                if let e = error {
                    print("Error saving workout history: \(e)")
                } else {
                    print("Succesfully saved workout history!")
                }
            }
        }
    }
    
    
    @IBAction func finishButtonPressed(_ sender: UIButton) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        // Pop back to home screen
        self.navigationController!.popToViewController(viewControllers[2], animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
