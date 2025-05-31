//
//  User.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct User: Codable {
    var id: UUID
    var email: String
    var password: String
    var name: String
    var balance: Int
    var totalBalance: Int
    
    init(id: UUID = UUID(), email: String, password: String, name: String, balance: Int, totalBalance: Int) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.balance = balance
        self.totalBalance = totalBalance
    }
}
