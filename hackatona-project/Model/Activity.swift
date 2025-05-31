//
//  Events.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Activity: Identifiable, Codable {
    let id: UUID
    let name: String
    let type: String
    let averageRating: Double
    let date: Date
    let image: String
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
    
    init(id: UUID = UUID(), name: String, type: String, averageRating: Double, date: Date, image: String) {
        self.id = id
        self.name = name
        self.type = type
        self.averageRating = averageRating
        self.date = date
        self.image = image
    }
}
