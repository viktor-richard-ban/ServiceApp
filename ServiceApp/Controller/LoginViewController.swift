//
//  LoginViewController.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 04. 26..
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.black.cgColor
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.black.cgColor
        
        submitButton.layer.borderWidth = 1
        submitButton.layer.borderColor = UIColor.black.cgColor
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text {
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                if let error = error {
                    print("Error: \(error)")
                    
                    let alert = UIAlertController(title: "Hiba", message: "Rossz felhasználónév vagy jelszó", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Rendben", style: UIAlertAction.Style.default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                    
                    return
                }
                
                if let result = authResult {
                    let userDictionary = [
                        "id": result.user.uid,
                        "email": result.user.email
                    ]
                    
                    UserDefaults.standard.setValue(userDictionary, forKey: "user")
                    
                    self?.performSegue(withIdentifier: "loggedIn", sender: self)
                }
            }
        }
    }
}
