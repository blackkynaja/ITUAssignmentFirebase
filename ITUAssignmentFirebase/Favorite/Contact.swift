//
//  Contact.swift
//  ITUAssignmentFirebase
//
//  Created by Yutthapong Kawunruan on 10/11/22.
//

import Foundation

struct Contact: Codable {
    
    let firstName: String
    let lastName: String
    let phoneNumber: String
    
    var dictValue: NSDictionary {
        
        let data = try! JSONEncoder().encode(self)
        
        let value = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        
        return value as NSDictionary
    }
}
