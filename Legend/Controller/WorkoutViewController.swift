//
//  WorkoutViewController.swift
//  Legend
//
//  Created by Daniel Castro on 3/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import Firebase
import UIKit

class WorkoutViewController: UIViewController {
    let db = Firestore.firestore()
    var workouts: [Workout] = []
    var selectedWorkout: Workout? = nil
    
    @IBOutlet weak var workoutTableView: UITableView!
    
    
    override func viewDidLoad() {
        workoutTableView.delegate = self
        workoutTableView.dataSource = self
        workoutTableView.register(UINib(nibName: "ExerciseCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")

    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadWorkouts()
    }
    
    
    func loadWorkouts() {
        if let email = Auth.auth().currentUser?.email {
            db.collection("workoutData")
                .whereField("user", isEqualTo: email)
                .getDocuments()
                    { (querySnapshot, error) in
                        
                        self.workouts = []
                        
                        if let e = error {
                            print("There was an issue retrieving workout data from Firestore. \(e)")
                        } else {
                            if let snapshotDocuments = querySnapshot?.documents {
                                for doc in snapshotDocuments {
                                    let workoutId = doc.documentID
                                    let data = doc.data()
                                    if let workoutTitle = data["workoutName"] as? String, let exercises = data["exercises"] as? [String]{
                                        var workoutExercises:[Exercise] = []
                                        // Create Exercise object for each exercise in array
                                        for exercise in exercises {
                                            let newExercise = Exercise(title: exercise)
                                            workoutExercises.append(newExercise)
                                        }
                                        let newWorkout = Workout(title: workoutTitle, exercises: workoutExercises, id: workoutId)
                                        self.workouts.append(newWorkout)
                                        
                                        DispatchQueue.main.async {
                                            self.workoutTableView.reloadData()
                                        }
                                    }
                                }
                            }
                        }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutToActive" {
            let vc = segue.destination as! ActiveWorkoutController
            vc.workout = selectedWorkout
        }
    }

    
    func startWorkout(_ workout: Workout) {
        selectedWorkout = workout
        performSegue(withIdentifier: "workoutToActive", sender: self)
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

extension WorkoutViewController: UITableViewDataSource, UITableViewDelegate {
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = workouts[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! ExerciseCell
        
        cell.titleLabel.text = workout.title
        cell.exercisesLabel.text = ""
        
        for i in 0..<workout.exercises.count {
            cell.exercisesLabel.text! += "\(i+1). " + workout.exercises[i].title + "\n"
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let workout = workouts[indexPath.row]
        startWorkout(workout)
    }
    
    
}

