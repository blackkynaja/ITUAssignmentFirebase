//
//  RandomPeopleServiceProtocol.swift
//  ITUAPICall
//
//  Created by Yutthapong Kawunruan on 11/6/22.
//

import Foundation

protocol RandomUserServiceProtocol {
    func getRandomUsers(completion: @escaping (Result<[User], Error>) -> ())
}
