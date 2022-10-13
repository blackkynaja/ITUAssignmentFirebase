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

    @IBAction func showAddContact(_ sender: Any) {
        
        performSegue(withIdentifier: "showAddContact", sender: nil)
    }
    
}

extension ContactListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ContactListViewController: ContactListViewModelDelegate {
    
    func viewModelUpdated() {
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
}
