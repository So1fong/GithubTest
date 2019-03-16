//
//  ViewController.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 15.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

let request: Request = Request()
var buttonTapped = false

class AuthenticationVC: UIViewController, AlertControllerDelegate
{
    @IBOutlet weak var gitHubImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if let login = UserDefaults.standard.string(forKey: "login")
        {
            if let password = UserDefaults.standard.string(forKey: "password")
            {
                if login != "" && password != ""
                {
                    buttonTapped = false
                    authorizeAutomatically(login: login, password: password)
                }
            }
        }
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        let imageName = "GitHub-Mark.png"
        let image = UIImage(named: imageName)
        gitHubImageView.image = image
        request.alertControllerDelegate = self
    }
    
    func showConnectionAlertController()
    {
        DispatchQueue.main.async
        {
                let alertController = UIAlertController(title: "Ошибка", message: "Ошибка подключения", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func showAuthenticationAlertController()
    {
        DispatchQueue.main.async
        {
            let alertController = UIAlertController(title: "Ошибка", message: "Ошибка входа", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ок", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func authorizeAutomatically(login: String, password: String)
    {
        request.authenticationRequest(username: login, password: password)
        request.getReposRequest()
    }
    
    func authorizeWithLoginAndPassword()
    {
        if let login = loginTextField.text
        {
            if let password = passwordTextField.text
            {
                request.authenticationRequest(username: login, password: password)

            }
            request.getReposRequest()
        }
    }
    
    @IBAction func authButtonTapped(_ sender: Any)
    {
        buttonTapped = true
        let login = loginTextField.text
        let password = passwordTextField.text
        UserDefaults.standard.set(login, forKey: "login")
        UserDefaults.standard.set(password, forKey: "password")
        UserDefaults.standard.synchronize()
        authorizeWithLoginAndPassword()
    }
    
    func doSegue()
    {
        DispatchQueue.main.async
        {
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
}

