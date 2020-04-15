//
//  ActiveWorkoutController.swift
//  Legend
//
//  Created by Daniel Castro on 3/11/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class ActiveWorkout {
    var subscriber: ActiveWorkoutController
    var workout: Workout
    var workoutStats: [String: [[String: Int]]] = [:]
    var numOfExercises: Int
    var isActive: Bool
    var currentExercise: Int
    var currentTime: Int
    var timer: Timer
    
    init(workout: Workout, subscriber: ActiveWorkoutController) {
        self.subscriber = subscriber
        isActive = true
        currentExercise = 0
        currentTime = 0
        numOfExercises = workout.exercises.count
        timer = Timer()
        
        self.workout = workout
        for exercise in workout.exercises {
            self.workoutStats[exercise.title] = []
        }
    }
    
    func beginWorkout() {
        startTimer()
        notifySetLabel()
    }
    
    func currentExerciseTitle() -> String {
        return workout.exercises[currentExercise].title
    }
    
    func nextExercise() {
        // TODO: If this is last exercise, change button text to "Finish Workout"
        if currentExercise < workout.exercises.count - 1 {
            currentExercise += 1
            notifyExerciseLabel()
            notifySetLabel()
        }
        
        if currentExercise == workout.exercises.count - 1 {
            notifyFinishWorkout()
        }

    }
    
    func recordSet(reps: Int, weight: Int) {
        workoutStats[self.currentExerciseTitle()]?.append(["reps": reps, "weight": weight])
        notifySetLabel()
    }
    
    
    func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {_ in self.incrementTimer()})
    }
    
    func incrementTimer() {
        currentTime += 1
        notifyTimeLabel()
    }
    
    func notifyTimeLabel() {
        subscriber.updateTimeLabel(currentTime)
    }
    
    func notifyExerciseLabel() {
        if(currentExercise <= workout.exercises.count - 1) {
            subscriber.updateExerciseLabel(currentExerciseTitle())
        }
    }
    
    func notifySetLabel() {
        // Get the number of sets currently recorded for the current exercise
        let setNumber = workoutStats[self.currentExerciseTitle()]!.count + 1
        subscriber.updateSetLabel(setNumber)
    }
    
    func notifyFinishWorkout() {
        subscriber.updateExerciseButton(NSAttributedString(string:"Finish Workout"))
    }

}




class ActiveWorkoutController: UIViewController {
    
    @IBOutlet weak var exerciseLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var setLabel: UILabel!
    @IBOutlet weak var repsTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var nextExerciseButton: UIButton!
    
    var workout: Workout? = nil
    var activeWorkout: ActiveWorkout? = nil
    
    override func viewDidLoad() {
        activeWorkout = ActiveWorkout(workout: self.workout!, subscriber: self)
        exerciseLabel.text = activeWorkout?.currentExerciseTitle()
        // Start an active workout with the workout selected by user
        activeWorkout?.beginWorkout()
    }
    

    @IBAction func recordSetButtonPressed(_ sender: UIButton) {
        if let reps = repsTextField.text, let weight = weightTextField.text {
            if reps.isEmpty || weight.isEmpty {
                // Handle error, we need both values
            } else {
                activeWorkout?.recordSet(reps: Int(reps)!, weight: Int(weight)!)
                repsTextField.text = ""
                weightTextField.text = ""
            }
        }
    }
    
    
    @IBAction func nextExerciseButtonPressed(_ sender: UIButton) {
        // TODO: If this is last exercise, change button text to "Finish Workout"
        if sender.titleLabel?.text == "Finish Workout" {
            performSegue(withIdentifier: "workoutToSummary", sender: self)
        } else {
            activeWorkout?.nextExercise()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "workoutToSummary" {
            let vc = segue.destination as! WorkoutSummaryController
            vc.workoutStats = self.activeWorkout!.workoutStats
            vc.totalTime = timerLabel.text!
            vc.totalTimeInSecs = self.activeWorkout!.currentTime
        }
    }
    
    func updateTimeLabel(_ newTime: Int) {
        let hours = Int(newTime) / 3600
        let minutes = Int(newTime) / 60 % 60
        let seconds = Int(newTime) % 60
        let formattedString = String(format:"%02i:%02i:%02i", hours, minutes, seconds)
        timerLabel.text = "\(formattedString)"
    }
    
    func updateExerciseButton(_ newText: NSAttributedString) {
        nextExerciseButton.setAttributedTitle(newText , for: .normal)
    }
    
    func updateExerciseLabel(_ newExercise: String) {
        exerciseLabel.text = newExercise
    }
    
    func updateSetLabel(_ newSetNum: Int) {
        setLabel.text = "Set: \(newSetNum)"
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

