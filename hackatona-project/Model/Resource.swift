//
//  Resource.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

struct Resource: Identifiable, Codable {
    let id: String
    let type: String
    let name: String
    let averageRating: Double
    let photo: String
}
