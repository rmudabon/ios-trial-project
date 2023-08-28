//
//  DetailsViewController.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/25/23.
//

import UIKit

class DetailsViewController: UIViewController {

    var recipe: Recipe?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        // Do any additional setup after loading the view.
        if let safeRecipe = recipe {
            titleLabel.text = safeRecipe.name
            authorLabel.text = safeRecipe.author
            dateLabel.text = dateFormatter.string(from: Date(timeIntervalSince1970: safeRecipe.createdAt))
            descriptionLabel.text = safeRecipe.description
            ingredientsLabel.attributedText = bulletPointList(strings: safeRecipe.ingredients)
            instructionsLabel.attributedText = numberedList(strings: safeRecipe.instructions)
            
            if let currentUser = UserDefaults.standard.string(forKey: "user") {
                if safeRecipe.author == currentUser {
                    editBarButton.isEnabled = true
                    deleteBarButton.isEnabled = true
                }
            }
        }
        networkManager.delegate = self
    }
    
    func bulletPointList(strings: [String]) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let stringAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let string = strings.map({ "•\t\($0)" }).joined(separator: "\n")

        return NSAttributedString(string: string,
                                  attributes: stringAttributes)
    }
    
    func numberedList(strings: [String]) -> NSAttributedString {
        var fullString: String = ""
        var processedStrings: [String] = []
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.headIndent = 15
        paragraphStyle.minimumLineHeight = 39
        paragraphStyle.maximumLineHeight = 40
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: 15)]

        let stringAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        for (index, string) in strings.enumerated() {
            processedStrings.append("Step \(index + 1)\t\(string)" )
        }

        fullString = processedStrings.joined(separator: "\n")
        return NSAttributedString(string: fullString,
                                  attributes: stringAttributes)
    }

    @IBAction func editPressed(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func deletePressed(_ sender: Any) {
        let alert = UIAlertController(title: "Delete Recipe", message: "Are you sure you want to delete this recipe?\nThis action cannot be undone!", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            if let recipeID = self.recipe?.id {
                self.networkManager.deleteRecipe(with: recipeID)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        present(alert, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? RecipeFormViewController {
            controller.existingInfo = recipe
        }
    }
}

extension DetailsViewController: NetworkManagerDelegate {
    func networkManagerDidSendError(_ networkManager: NetworkManager, error errorMessage: String) {
        DispatchQueue.main.async {
            let errorAlert = UIAlertController(title: "Error", message: "There is an issue deleting the recipe.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm", style: .cancel)
            errorAlert.addAction(confirmAction)
            self.present(errorAlert, animated: true)
        }
    }
    
    func networkManagerDidSuccessfulRequest(_ networkManager: NetworkManager, optionalData data: Data?) {
        DispatchQueue.main.async {
            let successAlert = UIAlertController(title: "Success", message: "Recipe successfully deleted.", preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Confirm", style: .cancel) { _ in
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            successAlert.addAction(confirmAction)
            self.present(successAlert, animated: true)
        }
    }
    
    
}
