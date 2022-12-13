//
//  Person.swift
//  ITUAPICall
//
//  Created by Yutthapong Kawunruan on 11/6/22.
//

import Foundation

struct User: Codable {
    let gender: String
    let email: String
    let phone: String
    let name: NameResponse
    let location: LocationResponse
    let id: IdentifierResponse
}

struct NameResponse: Codable {
    let title: String
    let first: String
    let last: String
}

struct LocationResponse: Codable {
    let street: StreetResponse
    let city: String
    let state: String
    let country: String
}

struct StreetResponse: Codable {
    let number: Int
    let name: String
}

struct IdentifierResponse: Codable {
    let name: String
    let value: String?
}
