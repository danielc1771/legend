//
//  WorkoutHistoryController.swift
//  Legend
//
//  Created by Daniel Castro on 3/30/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class WorkoutHistoryController : UIViewController {
    let db = Firestore.firestore()
    @IBOutlet weak var workoutHistoryTableView: UITableView!
    var workouts: [WorkoutHistory] = []
    
    override func viewDidLoad() {
        workoutHistoryTableView.delegate = self
        workoutHistoryTableView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadHistory()
    }
    
    
    func loadHistory() {
        if let email = Auth.auth().currentUser?.email {
            db.collection("workoutHistory")
                .whereField("user", isEqualTo: email)
                .getDocuments()
                    { (querySnapshot, error) in
                        self.workouts = []
                        
                        if let e = error {
                            print("There was an issue retrieving workout data from Firestore. \(e)")
                        } else {
                            if let snapshotDocuments = querySnapshot?.documents {
                                for doc in snapshotDocuments {
                                    let data = doc.data()
                                    if let workoutDate = data["date"] as? Double, let type = data["type"] as? String, let expGained = data["expGained"] as? Int, let duration = data["duration"] as? String {
                                        var strWorkout: [String: [[String: Int]]] = ["": [["":0]]]
                                        var agiWorkout: [String: String] = ["": ""]
                                        if type == "STR" {
                                            strWorkout = (data["workout"] as? [String: [[String: Int]]])!
                                        } else if type == "AGI" {
                                            agiWorkout = (data["workout"] as? [String: String])!
                                        }
                                        
                                        let newHistory = WorkoutHistory(date: workoutDate, strWorkout: strWorkout, agiWorkout: agiWorkout, duration: duration, expGained: expGained, type: type)
                                        self.workouts.append(newHistory)
                                    }
                                }
                                DispatchQueue.main.async {
                                    // Sort history by date
                                    self.workouts = self.workouts.sorted(by: {$0.dateObj.compare($1.dateObj) == .orderedDescending})
                                    self.workoutHistoryTableView.reloadData()
                                }
                            }
                        }
            }
        }
    }
    
    func calculateDayOfWeek(_ date: Double) -> (String, String) {
        let weekdays = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday"
        ]
        let dateObj = Date(timeIntervalSince1970: date)
        // Get the hour string
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mma"
        let hourString =  dateFormatter.string(from: dateObj)
        // Get the day of the week
        let calendar = Calendar(identifier: .gregorian)
        let dayOfWeek = calendar.component(.weekday, from: dateObj)
        
        let workoutDayOfWeek = weekdays[dayOfWeek - 1] + ", \(hourString)"
        // Get the calendarDay
        dateFormatter.dateFormat = "LLLL dd, yyyy"
        let calendarDay = dateFormatter.string(from: dateObj)
        
        return (workoutDayOfWeek, calendarDay)
    }
}

extension WorkoutHistoryController: UITableViewDataSource, UITableViewDelegate {
    private func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return workouts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let workout = workouts[indexPath.row]
        
        let (workoutDayOfWeek, workoutCalendarDay) = calculateDayOfWeek(workout.date)
        
        var cell = tableView.dequeueReusableCell(withIdentifier:"WorkoutHistoryCell", for: indexPath) as! WorkoutHistoryCell
        cell.containerView.layer.cornerRadius = cell.containerView.frame.size.height / 8
        cell.dayOfWeekTextLabel.text = workoutDayOfWeek
        cell.calendarDayTextLabel.text = workoutCalendarDay
        cell.durationTextLabel.text = workout.duration
        cell.expGainedTextLabel.text = "\(workout.expGained)"
        
        if workout.type == "STR" {
            cell = createStrCell(cell, workout)
        } else if workout.type == "AGI" {
            cell = createAgiCell(cell, workout)
        }
        
        
        
        return cell
    }
    
    func createStrCell(_ cell: WorkoutHistoryCell, _ workout: WorkoutHistory) -> WorkoutHistoryCell {
        var exerciseCount = 0
        var exercises = ""
        
        for exercise in workout.strWorkout {
            exerciseCount += 1
            exercises += "\n\(exerciseCount). \(exercise.key)"
        }
        cell.exercisesTextLabel.text = "Exercises:"
        cell.exercisesTextLabel.text! += exercises
        cell.exerciseCountTextLabel.text = "\(exerciseCount)"
        
        return cell
    }
    
    func createAgiCell(_ cell: WorkoutHistoryCell, _ workout: WorkoutHistory) -> WorkoutHistoryCell {
        cell.exerciseCountTextLabel.text = workout.agiWorkout["activity"]
        cell.exercisesTextLabel.text = ""
        cell.activityTextLabel.text = "Activity"
        return cell
    }
    
    
    
}
