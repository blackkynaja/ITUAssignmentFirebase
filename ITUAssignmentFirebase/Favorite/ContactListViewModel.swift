//
//  ContactListViewModel.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/12/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

protocol ContactListViewModelDelegate: NSObject {
    func viewModelUpdated()
}

class ContactListViewModel: NSObject {
    
    weak var delegate: ContactListViewModelDelegate?
    
    private lazy var contactRef: DatabaseReference = {
      let ref = Database.database()
        .reference()
        .child("users/\(Auth.auth().currentUser!.uid)/contacts")
      return ref
    }()
    
//    let contactRef = Database.database().reference().child("contacts")
    var contacts = [ContactViewModel]() {
        didSet {
            self.delegate?.viewModelUpdated()
        }
    }
    
    override init() {
        super.init()
        
        contactRef.observe(.value) { [weak self] (snapshot) in
            var temp = [ContactViewModel]()
            for child in snapshot.children.allObjects as! [DataSnapshot] {
                let dict = child.value as! [String: Any]
                let key = child.key
                let viewModel = ContactViewModel(key: key, dict: dict)
                temp.append(viewModel)
            }
            self?.contacts = temp
        }
    }
}

extension ContactListViewModel: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.cellIdentifier(), for: indexPath) as? ContactTableViewCell else {
            return UITableViewCell()
        }
        
        cell.viewModel = contacts[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contacts.count
    }
}
