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
    
    func register(username: String, password: String) {
        guard let loginURL = URL(string: "\(Constants.baseURL)\(Constants.Endpoints.login)") else { return }
        
        var registerRequest = URLRequest(url: loginURL)
        let rawBody: [String: Any] = [
            "username": username,
            "token": username,
            "isAdmin": false
        ]
        let data = try? JSONSerialization.data(withJSONObject: rawBody)
        registerRequest.httpMethod = "POST"
        registerRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        registerRequest.httpBody = data
        
        let loginTask = urlSession.dataTask(with: registerRequest, completionHandler: handleResponse(data:response:error:))
        
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
    
    func editRecipe(with data: Data?, id recipeID: String){
        guard let recipeURL = URL(string: "\(Constants.baseURL)\(Constants.Endpoints.recipes)/\(recipeID)") else { return }
        
        var recipeRequest = URLRequest(url: recipeURL)
        recipeRequest.httpMethod = "PUT"
        recipeRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        recipeRequest.httpBody = data
        let fetchTask = urlSession.dataTask(with: recipeRequest, completionHandler: handleResponse(data:response:error:))
        fetchTask.resume()
    }
    
    func deleteRecipe(with id: String) {
        guard let recipeURL = URL(string: "\(Constants.baseURL)\(Constants.Endpoints.recipes)/\(id)") else { return }
        var recipeRequest = URLRequest(url: recipeURL)
        recipeRequest.httpMethod = "DELETE"
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
