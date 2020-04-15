//
//  CreateWorkoutController.swift
//  Legend
//
//  Created by Daniel Castro on 3/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit

class CreateWorkoutNameController : UIViewController {
    @IBOutlet weak var workoutTitleTextField: UITextField!
    var workoutName = ""
    
    @IBAction func workoutTitleButtonPressed(_ sender: UIButton) {
        if workoutTitleTextField.text != "" {
            self.workoutName = workoutTitleTextField.text!
            performSegue(withIdentifier: "nameToOverview", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CreateWorkoutOverviewController
        vc.workoutName = self.workoutName
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
