//
//  RegisterViewController.swift
//  Legend
//
//  Created by Daniel Castro on 2/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var birthDateTextfield: UITextField!
    @IBOutlet weak var genderTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    private var datePicker: UIDatePicker?
    private var genderPicker: UIPickerView?
    
    var newUserData : [String: Any] = [:]
    let genderOptions = ["Male", "Female"]
    
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set nav bar color
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.3526402712, green: 0.5031716228, blue: 0.9141635895, alpha: 1)
        // Button rounded corners
        nextButton.layer.cornerRadius = 25
        // Dismiss on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        
        view.addGestureRecognizer(tapGesture)
        
        // Set up date picker for user date of birth
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(self.dateChanged(datePicker:)),
                              for: .valueChanged)
        birthDateTextfield.inputView = datePicker
        
        // Set up gender picker for user gender
        genderPicker = UIPickerView()
        genderPicker?.delegate = self
        genderTextfield.inputView = genderPicker
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        birthDateTextfield.text = dateFormatter.string(from: datePicker.date)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        // Create the user account
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    // Navigate to Select Character screen
                    self.saveUserInfo()
                    self.performSegue(withIdentifier: "registerToSelect", sender: self)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "registerToSelect" {
            let vc = segue.destination as! SelectCharacterViewController
            vc.newUserData = newUserData
        }
    }
    
    func saveUserInfo() {
        if let firstName =  firstNameTextfield.text, let lastName = lastNameTextfield.text,
            let birthDate = birthDateTextfield.text, let gender = genderTextfield.text, let email = Auth.auth().currentUser?.email {
            newUserData["firstName"] = firstName
            newUserData["lastName"] = lastName
            newUserData["birthDate"] = birthDate
            newUserData["gender"] = gender
            newUserData["email"] = email
            newUserData["strengthXP"] = 0
            newUserData["agilityXP"] = 0
            newUserData["creationDate"] = Date().timeIntervalSince1970
            newUserData["character"] = ["equppied": []]
        }
    }
}

extension RegisterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderOptions[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderOptions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        genderTextfield.text = genderOptions[row]
    }
}
