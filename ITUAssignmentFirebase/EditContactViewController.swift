//
//  EditContactViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/18/22.
//

import UIKit
import FirebaseDatabase

class EditContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var viewModel: ContactViewModel!
    
    var contactRef = Database.database().reference().child("contacts")
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Edit Contact"
        
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        phoneNumberTextField.text = viewModel.phoneNumber
        
    }
    
    @IBAction func editContact() {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        let newValue = contactRef.child(viewModel.identifier)
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        
        newValue.setValue(contact.dictValue)
        newValue.setValue(contact.dictValue) { [weak self] (error, _) in
            
            if let error = error {
                print("add data to firebase error: \(error)")
            } else {
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

