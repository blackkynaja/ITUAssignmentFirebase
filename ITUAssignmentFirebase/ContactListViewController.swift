//
//  ViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/11/22.
//

import UIKit
import FirebaseDatabase

class ContactListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = ContactListViewModel()
    
    private let showAddContactSegue = "showAddContact"
    private let showEditContactSegue = "showEditContact"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Contacts"
        
        viewModel.delegate = self
        tableView.dataSource = viewModel
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == showEditContactSegue, let vc = segue.destination as? EditContactViewController, let viewModel = sender as? ContactViewModel {
            
            vc.viewModel = viewModel
        }
    }

    @IBAction func showAddContact(_ sender: Any) {
        
        performSegue(withIdentifier: showAddContactSegue, sender: nil)
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
