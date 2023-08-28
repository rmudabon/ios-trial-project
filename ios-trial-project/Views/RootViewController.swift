//
//  RootViewController.swift
//  ios-trial-project
//
//  Created by Rowmel Marco Dabon on 8/24/23.
//

import UIKit

class RootViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let _ = UserDefaults.standard.string(forKey: "user"){
            performSegue(withIdentifier: Constants.Segue.rootSegue, sender: self)
        }
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
