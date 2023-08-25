//
//  Constants.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/22/23.
//

import Foundation

struct Constants {
    static let baseURL = "https://63c14da499c0a15d28e672cf.mockapi.io/ios-trial"
    struct Endpoints {
        static let login = "/login"
        static let recipes = "/recipes"
    }
    
    struct Segue {
        static let loginSegue = "loginGoToList"
        static let registerSegue = "registerGoToList"
        static let rootSegue = "rootGoToList"
        static let detailsSegue = "listGoToDetails"
    }
}
