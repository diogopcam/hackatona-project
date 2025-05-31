//
//  Resource.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Resource: Identifiable, Codable {
    let id: UUID
    let type: String
    let name: String
    let averageRating: Double
    let photo: String
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
    
    init(id: UUID = UUID(), type: String, name: String, averageRating: Double, photo: String) {
        self.id = id
        self.type = type
        self.name = name
        self.averageRating = averageRating
        self.photo = photo
    }
}
