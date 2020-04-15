//
//  CreateWorkoutOverviewController.swift
//  Legend
//
//  Created by Daniel Castro on 3/9/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class CreateWorkoutOverviewController: UIViewController {
    let db = Firestore.firestore()
    var workoutName = ""
    var exercisesToAdd: [String] = []
    @IBOutlet weak var workoutNameLabel: UILabel!
    @IBOutlet weak var exerciseTableView: UITableView!
    
    override func viewDidLoad() {
        workoutNameLabel.text = workoutName
        exerciseTableView.dataSource = self
    }

    @IBAction func addExercisesButtonPressed(_ sender: UIButton) {    
        performSegue(withIdentifier: "overviewToSelect", sender: self)
    }
    
    @IBAction func createWorkoutButtonPressed(_ sender: UIBarButtonItem) {
        if exercisesToAdd.count > 0 {
            createWorkout()
        } else {
            // Handle empty workout
        }
    }
    
    func createWorkout() {
        if let email = Auth.auth().currentUser?.email {
            db.collection("workoutData").addDocument(data: [
                "user": email,
                "workoutName": workoutName,
                "exercises": exercisesToAdd
            ]) { (error) in
                if let e = error {
                    print("Error saving workout: \(e)")
                } else {
                    print("Succesfully saved workout!")
                    DispatchQueue.main.async {
                        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
                    }
                }
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CreateWorkoutSelectionController
        vc.delegate = self
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

extension CreateWorkoutOverviewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercisesToAdd.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        
        cell.textLabel?.text = exercisesToAdd[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            exercisesToAdd.remove(at: indexPath.row)
            self.exerciseTableView.reloadData()
        }
    }
    

}

extension CreateWorkoutOverviewController: AddExerciseDelegate {
    func addExercises(exercises: [String]) {
        navigationController?.popViewController(animated: true)
        for exercise in exercises {
            self.exercisesToAdd.append(exercise)
        }
        self.exerciseTableView.reloadData()
    }
}
