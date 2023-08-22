//
//  LoginInfo.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/22/23.
//

import Foundation

struct LoginInfo: Decodable {
    let id: String
    let username: String
    let token: String
    let isAdmin: Bool
}

struct Recipe: Codable {
    let id: String
    let createdAt: String
    let name: String
    let ingredients: [String]
    let instructions: [String]
    let description: String
}
