//
//  NetworkManager.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/22/23.
//

import Foundation

protocol NetworkManagerDelegate {
    func networkManagerDidSendError(_ networkManager: NetworkManager, error errorMessage: String)
    func networkManagerDidSuccessfulRequest(_ networkManager: NetworkManager, optionalData data: Data?)
}

struct NetworkManager {
    
    var urlSession = URLSession.shared
    var delegate: NetworkManagerDelegate?
    
    func login(username: String, password: String) {
        guard let loginURL = URL(string: "\(Constants.baseURL)\(Constants.Endpoints.login)") else { return }
        
        var loginRequest = URLRequest(url: loginURL)
        loginRequest.httpMethod = "GET"
        
        let loginTask = urlSession.dataTask(with: loginRequest, completionHandler: handleResponse(data:response:error:))
        
        loginTask.resume()
    }
    
    func fetchRecipes() {
        guard let recipeURL = URL(string: "\(Constants.baseURL)\(Constants.Endpoints.recipes)") else { return }
        
        let recipeRequest = URLRequest(url: recipeURL)
        let fetchTask = urlSession.dataTask(with: recipeRequest, completionHandler: handleResponse(data:response:error:))
        fetchTask.resume()
    }
    
    func addRecipes(with data: Data?){
        guard let recipeURL = URL(string: "\(Constants.baseURL)\(Constants.Endpoints.recipes)") else { return }
        
        var recipeRequest = URLRequest(url: recipeURL)
        recipeRequest.httpMethod = "POST"
        recipeRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        recipeRequest.httpBody = data
        let fetchTask = urlSession.dataTask(with: recipeRequest, completionHandler: handleResponse(data:response:error:))
        fetchTask.resume()
    }
    
    func handleResponse(data: Data?, response: URLResponse?, error: Error?) {
        if let detectedError = error {
            self.delegate?.networkManagerDidSendError(self, error: detectedError.localizedDescription)
        }
        else {
            self.delegate?.networkManagerDidSuccessfulRequest(self, optionalData: data)
        }
    }
}
