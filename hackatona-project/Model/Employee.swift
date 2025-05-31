//
//  Collaborator.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Employee: Identifiable, Codable {
    let id: UUID
    let email: String
    let password: String
    let name: String
    let cargo: String
    let image: String
    let qrCode: String
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
    
    init(id: UUID = UUID(), email: String, password: String, name: String, cargo: String, image: String, qrCode: String) {
        self.id = id
        self.email = email
        self.password = password
        self.name = name
        self.cargo = cargo
        self.image = image
        self.qrCode = qrCode
    }
}
