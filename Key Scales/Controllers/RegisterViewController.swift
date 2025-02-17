//
//  RegisterViewController.swift
//  Key Scales
//
//  Created by SD43 on 2/7/25.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth


class RegisterViewController: UIViewController {
    
    
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let email = emailTextfield.text, let password = passwordTextfield.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.showAlert(message: "Invalid input credentials.")
                } else {
                    self.performSegue(withIdentifier: "registerSegue", sender: self)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
}
    
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ emailTextfield: UITextField) -> Bool {
        view.endEditing(true)
    }
}
