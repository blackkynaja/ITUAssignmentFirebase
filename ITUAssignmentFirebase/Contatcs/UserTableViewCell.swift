//
//  UserTableViewCell.swift
//  ITUAPICall
//
//  Created by Yutthapong Kawunruan on 11/6/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: UserTableViewCell.self)
    
    @IBOutlet weak var genderImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    var viewModel: UserViewModel! {
        didSet {
            updateUI()
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func updateUI() {
        
        genderImageView.image = UIImage(named: viewModel.imageName)
        nameLabel.text = viewModel.name
        emailLabel.attributedText = NSAttributedString(string: viewModel.email, attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        addressLabel.text = viewModel.address
    }
}
