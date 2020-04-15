//
//  CreateWorkoutSelectionController.swift
//  Legend
//
//  Created by Daniel Castro on 3/9/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

protocol AddExerciseDelegate {
    func addExercises(exercises: [String])
}

class CreateWorkoutSelectionController: UIViewController {
    
    
    var delegate: AddExerciseDelegate?
    var exercises: [String] = []
    var exercisesToAdd: [String] = []
    
    @IBOutlet weak var exerciseTableView: UITableView!
    
    override func viewDidLoad() {
        loadExercises()
        exerciseTableView.delegate = self
        exerciseTableView.dataSource = self
    }
    
    func loadExercises() {
        for exercise in Exercises.chest {
            self.exercises.append(exercise)
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.addExercises(exercises: exercisesToAdd)
    }
    
    func addExercise(_ exerciseName: String) {
        exercisesToAdd.append(exerciseName)
    }
    
    func removeExercise(_ exerciseName: String) {
        if exercisesToAdd.contains(exerciseName) {
            if let index = exercisesToAdd.firstIndex(of: exerciseName) {
                exercisesToAdd.remove(at: index)
            }
        }
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

extension CreateWorkoutSelectionController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return exercises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "exerciseCell", for: indexPath)
        
        cell.textLabel?.text = exercises[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            // If we have already selected this exercise, remove it.
            if cell.contentView.backgroundColor == #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1) {
                removeExercise(exercises[indexPath.row])
                cell.contentView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            } else {
            // Otherwise add it to our exercise array
                addExercise(exercises[indexPath.row])
                cell.contentView.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
            }
        }


    }
    
    
}

