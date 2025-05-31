//
//  Benefits.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Benefit: Identifiable, Codable {
    let id: UUID
    let name: String
    let description: String
    let value: Int
    
    init(id: UUID = UUID(), name: String, description: String, value: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.value = value
    }
}
