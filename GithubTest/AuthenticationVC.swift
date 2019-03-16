//
//  ViewController.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 15.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

class AuthenticationVC: UIViewController
{
    @IBOutlet weak var gitHubImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    let request: Request = Request()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let imageName = "GitHub-Mark.png"
        let image = UIImage(named: imageName)
        gitHubImageView.image = image
        
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    @IBAction func authButtonTapped(_ sender: Any)
    {
        
        if let login = loginTextField.text
        {
            if let password = passwordTextField.text
            {
                request.authenticationRequest(username: login, password: password)
            }
        }
        DispatchQueue.main.async {
            self.request.getReposRequest()
        }
    }
    
}

