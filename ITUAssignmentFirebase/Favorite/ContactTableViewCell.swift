//
//  ContactTableViewCell.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/12/22.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    
    class func cellIdentifier() -> String {
        
        return String(describing: self)
    }
    
    var viewModel: ContactViewModel! {
        didSet {
            updateContent()
        }
    }
    
    private func updateContent() {
        
        nameLabel.text = viewModel.name
        phoneNumberLabel.text = viewModel.phoneNumber
        
    }
}
