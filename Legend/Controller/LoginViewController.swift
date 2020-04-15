//
//  LoginViewController.swift
//  Legend
//
//  Created by Daniel Castro on 2/8/20.
//  Copyright © 2020 Daniel Castro. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set nav bar color
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)
        // Button rounded corners
        loginButton.layer.cornerRadius = 25
        // Dismiss on tap
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecognizer:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    self.performSegue(withIdentifier: "loginToHome", sender: self)
                }
            }
        }
    }
}

