//
//  ViewController.swift
//  MessagingApp
//
//  Created by Aleksandra Sobot on 23.5.24..
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = ""
        let titleText = K.appName
        var charIndex = 0.0
   
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { [weak self] (timer) in
                self?.titleLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }

}

