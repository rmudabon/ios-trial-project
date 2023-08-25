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
