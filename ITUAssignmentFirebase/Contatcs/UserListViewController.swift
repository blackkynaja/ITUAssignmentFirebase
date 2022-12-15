//
//  ViewController.swift
//  ITUAPICall
//
//  Created by Yutthapong Kawunruan on 11/6/22.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class UserListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private lazy var contactRef: DatabaseReference = {
      let ref = Database.database()
        .reference()
        .child("users/\(Auth.auth().currentUser!.uid)/contacts")
      return ref
    }()
    
    private let showLoginSegue = "showLoginPage"
    private let showCaptureQRPage = "showCaptureQRView"
    
    private let viewModel = UserListViewModel(service: RandomUserService())

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel.delegate = self
        viewModel.fetchUsers()
    }
    
    @IBAction func refresh() {
        
        viewModel.fetchUsers()
    }
    
    @IBAction func leftBarButtonTapped() {
        if isUserLoggedin() {
            showCameraPage()
        } else {
            showLoginPage()
        }
    }
    
    private func isUserLoggedin() -> Bool {
        return Auth.auth().currentUser != nil
    }
    
    private func showLoginPage() {
        tabBarController?.performSegue(withIdentifier: showLoginSegue, sender: nil)
    }
    
    private func showCameraPage() {
        tabBarController?.performSegue(withIdentifier: showCaptureQRPage, sender: nil)
    }
    
    private func addContact(item: UserViewModel) {
        
        let contact = Contact(firstName: item.firstname, lastName: item.lastname, phoneNumber: item.phone)
        let newValue = contactRef.child(item.id)
        
        newValue.setValue(contact.dictValue)
        newValue.setValue(contact.dictValue) { [weak self] (error, _) in
            
            if let error = error {
                print("add data to firebase error: \(error)")
                let alert = UIAlertController(title: "Error", message: "Something Wrong.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            } else {
                print("add data to firebase successfully")
                
                let alert = UIAlertController(title: "Add Contact", message: "Add this contact to favortie list successfully.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Close", style: UIAlertAction.Style.default, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfUser
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.identifier, for: indexPath) as? UserTableViewCell else { return UITableViewCell() }
        
        cell.viewModel = viewModel.getItemAtIndex(indexPath.row)
        
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isUserLoggedin() {
            let item = viewModel.getItemAtIndex(indexPath.row)!
            addContact(item: item)
        } else {
            showLoginPage()
        }
    }
}

extension UserListViewController: UserListViewModelDelegate {
    
    func usersUpdatedSuccessfully() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func usersUpdatedError(error: Error) {
        
    }
}
