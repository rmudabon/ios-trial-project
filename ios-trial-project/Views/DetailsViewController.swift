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
        }
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

}
