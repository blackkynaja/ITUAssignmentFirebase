//
//  RandomUserService.swift
//  ITUAPICall
//
//  Created by Yutthapong Kawunruan on 11/6/22.
//

import Foundation

class RandomUserService: RandomUserServiceProtocol {
    
    let endpoint = "https://randomuser.me/api/?results=20"
    
    func getRandomUsers(completion: @escaping (Result<[User], Error>) -> ()) {
        
        guard let url = URL(string: endpoint) else { return print("Invalid Endpoint") }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data, error == nil {
                
                do {
                    let randomUsersResponse = try JSONDecoder().decode(RandomUsersResponse.self, from: data)
                    completion(.success(randomUsersResponse.results))
                } catch {
                    print(error)
                    completion(.failure(NSError(domain: "Cannot Decode JSON", code: 0)))
                }
            } else {
                completion(.failure(error ?? NSError(domain: "Something wrong", code: 0)))
            }
        }.resume()
    }
}

struct RandomUsersResponse: Codable {
    let results: [User]
}
