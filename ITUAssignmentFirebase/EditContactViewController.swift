//
//  EditContactViewController.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/18/22.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class EditContactViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var qrCodeImage: UIImageView!
    
    var viewModel: ContactViewModel!
    
    private lazy var contactRef: DatabaseReference = {
      let ref = Database.database()
        .reference()
        .child("users/\(Auth.auth().currentUser!.uid)/contacts")
      return ref
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        title = "Edit Contact"
        
        firstNameTextField.text = viewModel.firstName
        lastNameTextField.text = viewModel.lastName
        phoneNumberTextField.text = viewModel.phoneNumber
        
        let newValue = contactRef.child(viewModel.identifier)
        print(newValue.description())
        if let qrImage = generateQRCode(from: newValue.description()) {
            qrCodeImage.image = qrImage
        }
        
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        let context = CIContext()

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 16, y: 16)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                if let retImg = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: retImg)
                }
            }
        }
        return nil
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

