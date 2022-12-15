//
//  ContactViewModel.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/12/22.
//

import Foundation

class ContactViewModel {
    
    private var contact: Contact
    
    let identifier: String
    
    var name: String {
        return "\(contact.firstName) \(contact.lastName)"
    }
    
    var firstName: String {
        return contact.firstName
    }
    
    var lastName: String {
        return contact.lastName
    }
    
    var phoneNumber: String {
        return contact.phoneNumber
    }
    
    init(key: String, dict: [String: Any]) {
        
        self.identifier = key
        let data = try! JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
        let decoder = JSONDecoder()
        contact = try! decoder.decode(Contact.self, from: data)
    }
}

extension String {
    var alphanumeric: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().lowercased()
    }
}
