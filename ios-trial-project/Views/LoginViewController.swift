//
//  LoginViewController.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/22/23.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let userPlaceholderText = usernameTextField.placeholder ?? ""
        let passwordPlaceholderText = passwordTextField.placeholder ?? ""
        usernameTextField.attributedPlaceholder = NSAttributedString(string: userPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Placeholder")!])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordPlaceholderText, attributes: [NSAttributedString.Key.foregroundColor : UIColor(named: "Placeholder")!])
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        networkManager.delegate = self
    }

    
    @IBAction func loginPressed(_ sender: UIButton) {
        errorLabel.isHidden = true
        guard let username = usernameTextField.text, let password = passwordTextField.text else {
            return
        }
        if(username.isEmpty || password.isEmpty){
            showError(with: Errors.login)
            loginButton.isEnabled = true
        }
        else {
            disableLoginButton()
            networkManager.login(username: username, password: password)
        }
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
        loginButton.setTitle("Logging in...", for: .disabled)
        loginButton.isEnabled = false
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}


extension LoginViewController: NetworkManagerDelegate {
    func networkManagerDidSendError(_ networkManager: NetworkManager, error errorMessage: String) {
        errorLabel.text = "An issue occured."
        loginButton.isEnabled = true
    }
    
    func networkManagerDidSuccessfulRequest(_ networkManager: NetworkManager, optionalData data: Data?) {
        guard let safeData = data else { return }
        let decoder = JSONDecoder()
        do {
            let loginData = try decoder.decode([LoginInfo].self, from: safeData)
            UserDefaults.standard.set(loginData.first?.username, forKey: "user")
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Constants.Segue.loginSegue, sender: self)
            }
        }
        catch let error {
            errorLabel.text = "An issue occured."
            print(error.localizedDescription)
        }
    }
}
