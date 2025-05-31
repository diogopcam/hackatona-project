//
//  Collaborator.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Employee: Identifiable, Codable {
    let id: String
    let email: String
    let password: String
    let name: String
    let cargo: String
    let image: String
    let qrCode: String
}
