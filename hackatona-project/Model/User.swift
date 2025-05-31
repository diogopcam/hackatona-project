//
//  User.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct User: Identifiable, Encodable, Decodable {
    let id: UUID
    let email: String
    let password: String
    let fullName: String
    let balance: Double
    let averageStars: Double
    
    init(id: UUID = UUID(), email: String, password: String, fullName: String, balance: Double, averageStars: Double) {
        self.id = id
        self.email = email
        self.password = password
        self.fullName = fullName
        self.balance = balance
        self.averageStars = averageStars
    }
}

struct AllUsers: Codable {
    var users: [User]
}
