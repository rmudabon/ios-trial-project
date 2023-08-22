//
//  ViewController.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/22/23.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userPlaceholderText = usernameTextField.placeholder ?? ""
        let passwordPlaceholderText = passwordTextField.placeholder ?? ""
        usernameTextField.attributedPlaceholder = NSAttributedString(string: userPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Placeholder")!])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Placeholder")!])
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
    }

    
    @IBAction func loginPressed(_ sender: UIButton) {
        errorLabel.isHidden = true
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        if(username.isEmpty || password.isEmpty){
            showError(with: Errors.login)
            registerButton.isEnabled = true
        }
        disableLoginButton()
    }
    
    func showError(with errorText: Errors){
        switch errorText {
        case .login:
            errorLabel.text = "Username or password is empty."
        case .data:
            errorLabel.text = "Error connecting to server."
        }
        errorLabel.isHidden = false
    }
    
    func disableLoginButton() {
        registerButton.setTitle("Logging in...", for: .disabled)
        registerButton.isEnabled = false
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

