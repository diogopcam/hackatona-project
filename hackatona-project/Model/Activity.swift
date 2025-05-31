//
//  Events.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct Activity: Identifiable, Codable {
    let id: String
    let name: String
    let type: String
    let averageRating: Double
    let date: Date
    let image: String
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
}
