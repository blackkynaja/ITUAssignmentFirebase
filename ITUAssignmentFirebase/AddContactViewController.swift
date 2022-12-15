//
//  AddContactViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/11/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    private lazy var contactRef: DatabaseReference = {
      let ref = Database.database()
        .reference()
        .child("users/\(Auth.auth().currentUser!.uid)/contacts")
      return ref
    }()
    
    var contact: ContactViewModel? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Add Contact"
        
        if let contact = contact {
            setupUI(contact: contact)
        }
    }
    
    private func setupUI(contact: ContactViewModel) {
        
        firstNameTextField.text = contact.firstName
        lastNameTextField.text = contact.lastName
        phoneNumberTextField.text = contact.phoneNumber
    }
    
    @IBAction func addContact() {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let newValue = contactRef.child(contact!.identifier)
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        newValue.setValue(contact.dictValue)
        newValue.setValue(contact.dictValue) { [weak self] (error, _) in
            
            if let error = error {
                print("add data to firebase error: \(error)")
            } else {
                self?.dismiss(animated: true)
            }
        }
    }
}
