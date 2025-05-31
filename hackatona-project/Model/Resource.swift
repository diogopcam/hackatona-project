//
//  Resource.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Resource: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let averageRating: Double
    let photo: String?
    let description: String?
    let location: String?
    let capacity: Int?
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case averageRating = "average"
        case photo = "midia"
        case description, location, capacity
    }
}
