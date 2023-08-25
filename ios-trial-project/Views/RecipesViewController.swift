//
//  RecipesViewController.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/22/23.
//

import UIKit

class RecipesViewController: UIViewController {

    @IBOutlet weak var listTableView: UITableView!
    
    var recipeList: [Recipe] = []
    var networkManager = NetworkManager()
    var selectedRecipeRow: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        navigationItem.largeTitleDisplayMode = .automatic
        networkManager.delegate = self
        listTableView.dataSource = self
        listTableView.delegate = self
        setBarAppereance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.hidesBackButton = true
        networkManager.fetchRecipes()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationItem.hidesBackButton = false
    }
    
    func setBarAppereance() {
        let scrollAppearance = UINavigationBarAppearance()
        scrollAppearance.titleTextAttributes = [.foregroundColor: UIColor(named: "Secondary") ?? UIColor.green]
        scrollAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(named: "Secondary") ?? UIColor.green]
        
        let buttonScrollAppearance = UIBarButtonItemAppearance()
        buttonScrollAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(named: "Secondary") ?? UIColor.green]
        buttonScrollAppearance.highlighted.titleTextAttributes = [.foregroundColor: UIColor.label]
        buttonScrollAppearance.focused.titleTextAttributes = [.foregroundColor: UIColor.white]
        
        scrollAppearance.backButtonAppearance = buttonScrollAppearance
        
        navigationItem.standardAppearance = scrollAppearance
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == Constants.Segue.detailsSegue){
            if let controller = segue.destination as? DetailsViewController {
                controller.recipe = recipeList[selectedRecipeRow]
            }
        }
    }
}

extension RecipesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipeTitleCell", for: indexPath)
        cell.textLabel?.text = recipeList[indexPath.row].name
        return cell
    }
    
    
}

extension RecipesViewController: NetworkManagerDelegate {
    func networkManagerDidSendError(_ networkManager: NetworkManager, error errorMessage: String) {
        print(errorMessage)
    }
    
    func networkManagerDidSuccessfulRequest(_ networkManager: NetworkManager, optionalData data: Data?) {
        guard let safeData = data else {
            return
        }
        let decoder = JSONDecoder()
        do {
            let recipes = try decoder.decode([Recipe].self, from: safeData)
            recipeList = recipes
            DispatchQueue.main.async {
                self.listTableView.reloadData()
            }
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
}

extension RecipesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRecipeRow = indexPath.row
        performSegue(withIdentifier: Constants.Segue.detailsSegue, sender: self)
    }
}
