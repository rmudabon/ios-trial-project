//
//  RecipeFormViewController.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/25/23.
//

import UIKit

class RecipeFormViewController: UIViewController {
    
    var existingInfo: Recipe?
    var networkManager = NetworkManager()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var ingredientsTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setFormAppearance()
        networkManager.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    @IBAction func submitPressed(_ sender: UIButton) {
        disableSubmit()
        errorLabel.textColor = UIColor.clear
        guard let name = nameTextField.text, let description = descriptionTextView.text, let ingredients = ingredientsTextView.text, let instructions = instructionsTextView.text else { return }
        if(name.isEmpty || description.isEmpty || ingredients.isEmpty || instructions.isEmpty){
            errorLabel.textColor = UIColor.red
            errorLabel.text = "All fields are required."
            return
        }
        var splitIngredients: [String] = []
        var splitInstructions: [String] = []
        ingredients.enumerateLines { ingredient, _ in
            splitIngredients.append(ingredient)
        }
        instructions.enumerateLines { instruction, _ in
            splitInstructions.append(instruction)
        }
        guard let author = UserDefaults.standard.string(forKey: "user") else { return }
        let currentDate = Date.now.timeIntervalSince1970
        
        let body: [String: Any] = [
            "createdAt": currentDate,
            "name": name,
            "description": description,
            "author": author,
            "ingredients": splitIngredients,
            "instructions": splitInstructions,
        ]
        
        let jsonBody = try? JSONSerialization.data(withJSONObject: body)
        networkManager.addRecipes(with: jsonBody)
        
        
    }
    
    func setFormAppearance() {
        descriptionTextView.layer.borderWidth = 1.0
        ingredientsTextView.layer.borderWidth = 1.0
        instructionsTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.cornerRadius = 5.0
        ingredientsTextView.layer.cornerRadius = 5.0
        instructionsTextView.layer.cornerRadius = 5.0
        
        descriptionTextView.layer.borderColor = UIColor(named: "Secondary")?.cgColor
        ingredientsTextView.layer.borderColor = UIColor(named: "Secondary")?.cgColor
        instructionsTextView.layer.borderColor = UIColor(named: "Secondary")?.cgColor
    }
    
    func disableSubmit(){
        submitButton.setTitle("Adding Recipe..", for: .disabled)
        submitButton.isEnabled = false
    }
    
    func enableSubmit(){
        submitButton.isEnabled = true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeFormViewController: NetworkManagerDelegate {
    func networkManagerDidSendError(_ networkManager: NetworkManager, error errorMessage: String) {
        DispatchQueue.main.async {
            self.errorLabel.textColor = UIColor.red
            self.errorLabel.text = errorMessage
            self.enableSubmit()
        }
    }
    
    func networkManagerDidSuccessfulRequest(_ networkManager: NetworkManager, optionalData data: Data?) {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}
