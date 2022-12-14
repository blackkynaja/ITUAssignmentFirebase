//
//  ViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/11/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FacebookCore
import FacebookLogin

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loginButton: UIButton!
    
    private var viewModel: ContactListViewModel!
    
    private let showAddContactSegue = "showAddContact"
    private let showEditContactSegue = "showEditContact"
    private let showLoginSegue = "showLoginPage"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Favortie Users"
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        presentUI(isUserLoggedin: isUserLoggedin())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showEditContactSegue, let vc = segue.destination as? EditContactViewController, let viewModel = sender as? ContactViewModel {
            
            vc.viewModel = viewModel
        }
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        if isUserLoggedin() {
            logout()
        }
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        showLoginPage()
    }
    
    private func logout() {
        try? Auth.auth().signOut()
        let fbManager = LoginManager()
        fbManager.logOut()
        viewModel = nil
        
        let alert = UIAlertController(title: "Logout", message: "You've been logged out.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        presentUI(isUserLoggedin: false)
    }
    
    private func showLoginPage() {
        tabBarController?.performSegue(withIdentifier: showLoginSegue, sender: self)
    }
    
    private func isUserLoggedin() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func presentUI(isUserLoggedin: Bool) {
    
        if isUserLoggedin {
            tableView.isHidden = false
            loginButton.isHidden = true
            
            if viewModel == nil {
                viewModel = ContactListViewModel()
                viewModel.delegate = self
                tableView.dataSource = viewModel
                tableView.reloadData()
            }
        } else {
            tableView.isHidden = true
            loginButton.isHidden = false
        }
    }
    
}

extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showEditContactSegue, sender: viewModel.contacts[indexPath.row])
    }
}

extension ContactListViewController: ContactListViewModelDelegate {
    
    func viewModelUpdated() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
}

extension ContactListViewController: LoginViewControllerDelegate {
    func loginSuccessFully() {
        presentUI(isUserLoggedin: true)
    }
}
