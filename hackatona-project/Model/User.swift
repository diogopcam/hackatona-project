//
//  User.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct User: Identifiable, Encodable, Decodable {
    var id = UUID()
    let email: String
    let password: String
    let fullName: String
    let balance: Double
    let averageStars: Double
    let position: String
    
    init(id: UUID = UUID(), email: String, password: String, fullName: String, balance: Double, averageStars: Double, position: String) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.balance = balance
        self.averageStars = averageStars
        self.position = position
    }
}

struct AllUsers: Codable {
    var users: [User]
}
