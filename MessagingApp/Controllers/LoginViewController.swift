//
//  LoginViewController.swift
//  MessagingApp
//
//  Created by Aleksandra Sobot on 27.5.24..
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {

        navigationController?.navigationBar.tintColor = UIColor(named: K.BrandColor.brandPurple)
    }
    

    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = loginTextfield.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            
                if let error = error {
                    self.showAlert(message: error.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Login error!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "TRY AGAIN", style: .default))
        present(alert, animated: true)
    }
}
