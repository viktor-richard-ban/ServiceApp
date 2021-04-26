//
//  LoginViewController.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 04. 26..
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "loggedIn", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loggedIn" {
            if let destination = segue.destination as? WorksheetsViewController {
                print("Destinated")
            }
        }
    }
}
