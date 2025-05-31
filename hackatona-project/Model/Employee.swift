//
//  Collaborator.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Employee: Identifiable, Codable {
    let id: String
    let name: String
    let email: String
    let position: String
    let balance: Double
    let average: Double
    let qrcode: String?
    let password_hash: String?
    let midia: String?
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
    
    // For backward compatibility with existing code
    var cargo: String {
        return position
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, position, balance, average, qrcode, password_hash, midia
    }
}
