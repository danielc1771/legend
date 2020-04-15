//
//  AgilityViewController.swift
//  Legend
//
//  Created by Daniel Castro on 3/30/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class AgilityViewController: UIViewController {
    let db = Firestore.firestore()
    var user: User?
    var expGained: Int = 0
    
    @IBOutlet weak var activityTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var distanceTextField: UITextField!
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        let activity = activityTextField.text!
        let duration = durationTextField.text!
        let distance = distanceTextField.text!
        
        if activity.isEmpty || duration.isEmpty || distance.isEmpty {
            //TODO: handle a missing parameter
            print("Something's missing...")
        } else {
            let workout = [
                "activity": activity,
                "distance": distance
            ]
            calculateXP(duration, distance)
            storeAgilityData(workout)
            performSegue(withIdentifier: "agilityToSummary", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "agilityToSummary" {
            let vc = segue.destination as! AgilitySummaryController
            vc.expGained = expGained
            vc.activityText = activityTextField.text!
            vc.durationText = durationTextField.text!
            vc.distanceText = distanceTextField.text!
        }
    }
    
    func calculateXP(_ duration: String, _ distance: String) {
        let distanceAsDouble = Double(distance)!
        let durationAsMinutes = formatDuration(duration)
        expGained = Int(1.5 * (pow(durationAsMinutes, 0.8) * distanceAsDouble))
        updateUserAgilityXP(expGained)
    }
    
    func updateUserAgilityXP(_ expGained: Int) {
        if let userId = user?.id {
            let userRef = db.collection("userData").document(userId)
            userRef.updateData([
                "agilityXP": user!.agilityXP + expGained
            ]) { err in
            if let err = err {
                print("Error updating user agilityXP: \(err)")
            } else {
                print("User agilityXP successfully updated")
            }
            }
        }
    }
    
    func storeAgilityData(_ workout: [String: String]) {
        if let email = Auth.auth().currentUser?.email {
            db.collection("workoutHistory").addDocument(data: [
                "user": email,
                "date": Date().timeIntervalSince1970,
                "workout": workout,
                "duration": durationTextField.text!,
                "expGained": expGained,
                "type": "AGI"
            ]) { (error) in
                if let e = error {
                    print("Error saving workout history: \(e)")
                } else {
                    print("Succesfully saved workout history!")
                }
            }
        }
    }
    
    func formatDuration(_ duration: String) -> Double{
        // Get the total minutes from string of format HH:mm:ss
        let splitDuration = duration.split(separator: ":")
        let hours = Int(splitDuration[0])
        let minutes = Int(splitDuration[1])
        let seconds = Int(splitDuration[2])
        
        let hoursAsMinutes = hours! * 60
        let secondsAsMinutes = seconds! / 60
        return Double(hoursAsMinutes + minutes! + secondsAsMinutes)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = true
    }
}
