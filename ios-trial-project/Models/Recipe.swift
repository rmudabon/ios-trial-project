//
//  Recipe.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/24/23.
//

import Foundation

struct Recipe: Codable {
    let id: String
    let createdAt: Double
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let description: String
    let author: String
}
