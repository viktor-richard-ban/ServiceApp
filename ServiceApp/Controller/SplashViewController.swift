//
//  SplashViewController.swift
//  ServiceApp
//
//  Created by Bán Viktor on 2021. 05. 08..
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        getAuthenticationToken()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.isNavigationBarHidden = true
    }
    
    func getAuthenticationToken() {
        if let user = UserDefaults.standard.dictionary(forKey: "user") as? [String:String] {
            if let id = user["id"] {
                checkAuthentication(id: id)
            }
        }
        
        checkAuthentication(id: nil)
    }

    func checkAuthentication(id: String?) {
        if id != nil {
            performSegue(withIdentifier: "loggedIn", sender: self)
        } else {
            performSegue(withIdentifier: "login", sender: self)
        }
    }

}
