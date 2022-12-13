//
//  ViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/11/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
        
        if isUserLoggedin() {
            if viewModel == nil {
                viewModel = ContactListViewModel()
                viewModel.delegate = self
                tableView.dataSource = viewModel
            }
        } else {
            showLoginPage()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showEditContactSegue, let vc = segue.destination as? EditContactViewController, let viewModel = sender as? ContactViewModel {
            
            vc.viewModel = viewModel
        }
    }

    @IBAction func showAddContact(_ sender: Any) {
        showLoginPage()
//        performSegue(withIdentifier: showAddContactSegue, sender: nil)
    }
    
    private func showLoginPage() {
        performSegue(withIdentifier: showLoginSegue, sender: nil)
    }
    
    private func isUserLoggedin() -> Bool {
        return Auth.auth().currentUser != nil
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
