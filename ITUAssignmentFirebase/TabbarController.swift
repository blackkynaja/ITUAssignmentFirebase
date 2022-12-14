//
//  TabbarController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 12/13/22.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let desVC = segue.destination as? LoginViewController, let sourceVC = sender as? ContactListViewController {
            desVC.delegate = sourceVC
        }
    }
}
