//
//  PeopleListViewModel.swift
//  ITUAPICall
//
//  Created by Yutthapong Kawunruan on 11/6/22.
//

import Foundation

protocol UserListViewModelDelegate: AnyObject {
    func usersUpdatedSuccessfully()
    func usersUpdatedError(error: Error)
}

class UserListViewModel {
    
    weak var delegate: UserListViewModelDelegate?
    
    private let service: RandomUserServiceProtocol
    private var users: [UserViewModel]?
    
    var numberOfUser: Int {
        return users?.count ?? 0
    }
    
    init(service: RandomUserServiceProtocol) {
        
        self.service = service
    }
    
    func fetchUsers() {
        
        service.getRandomUsers { [weak self] result in
            
            switch result {
                
            case .success(let users):
                self?.users = users.map {UserViewModel(user: $0)}
                self?.delegate?.usersUpdatedSuccessfully()
                
            case .failure(let error):
                print("Network Error: \(error)")
                self?.delegate?.usersUpdatedError(error: error)
            }
        }
    }
    
    func getItemAtIndex(_ index: Int) -> UserViewModel? {
    
        guard let users = users else {
            return nil
        }
        
        if index >= users.count {
            fatalError("Index out of bound")
        }
        
        return users[index]
    }
}

enum Gender {
    case male
    case female
    case noData
}

class UserViewModel {
    private let user: User
    
    var id: String {
        
        let value = user.id.value ?? String(Int.random(in: 100000..<999999))
        return "\(user.id.name)\(value)"
    }
    
    var name: String {
        return "\(user.name.title). \(user.name.first) \(user.name.last)"
    }
    
    var firstname: String {
        return user.name.first
    }
    
    var lastname: String {
        return user.name.last
    }
    
    var phone: String {
        return user.phone
    }
    
    var gender: Gender {
        return user.gender == "male" ? .male : user.gender == "female" ? .female : .noData
    }
    
    var email: String {
        return user.email
    }
    
    var address: String {
        var result = "\(user.location.street.number) \(user.location.street.name)"
        result.append("\n")
        result.append("\(user.location.city), \(user.location.state), \(user.location.country)")
        
        return result
    }
    
    var imageName: String {
        switch gender {
        case .male:
            return "male_icon"
        case .female:
            return "female_icon"
        case .noData:
            return ""
        }
    }
    
    init(user: User) {
        self.user = user
    }
}
