//
//  AddContactViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/11/22.
//

import UIKit
import FirebaseDatabase

class AddContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    var ref: DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Add Contact"
        
    }
    
    @IBAction func addContact() {
        
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let phoneNumber = phoneNumberTextField.text ?? ""
        
        let contact = Contact(firstName: firstName, lastName: lastName, phoneNumber: phoneNumber)
        print(contact.dictValue)
        ref.child("contacts").childByAutoId().setValue(contact.dictValue)
    }
}
