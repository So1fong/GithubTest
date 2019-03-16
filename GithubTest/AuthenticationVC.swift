//
//  ViewController.swift
//  GithubTest
//
//  Created by Ekaterina Kozlova on 15.03.2019.
//  Copyright © 2019 Ekaterina Kozlova. All rights reserved.
//

import UIKit

let request: Request = Request()

class AuthenticationVC: UIViewController, AlertControllerDelegate
{
    @IBOutlet weak var gitHubImageView: UIImageView!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var authButton: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
    
    @IBAction func authButtonTapped(_ sender: Any)
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
    
    func doSegue()
    {
        DispatchQueue.main.async
        {
            self.performSegue(withIdentifier: "segue", sender: self)
        }
    }
    
}

