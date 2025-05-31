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
    let description: String?
    let createdAt: Date
    let updatedAt: Date
    
    var firstLetter: String {
        return String(name.prefix(1)).uppercased()
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, type, description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let updatedAtString = try container.decode(String.self, forKey: .updatedAt)
        
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        if let parsedCreatedAt = formatter.date(from: createdAtString) {
            createdAt = parsedCreatedAt
        } else {
            formatter.formatOptions = [.withInternetDateTime]
            if let parsedCreatedAt = formatter.date(from: createdAtString) {
                createdAt = parsedCreatedAt
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .createdAt,
                    in: container,
                    debugDescription: "Date string does not match expected format"
                )
            }
        }
        
        if let parsedUpdatedAt = formatter.date(from: updatedAtString) {
            updatedAt = parsedUpdatedAt
        } else {
            formatter.formatOptions = [.withInternetDateTime]
            if let parsedUpdatedAt = formatter.date(from: updatedAtString) {
                updatedAt = parsedUpdatedAt
            } else {
                throw DecodingError.dataCorruptedError(
                    forKey: .updatedAt,
                    in: container,
                    debugDescription: "Date string does not match expected format"
                )
            }
        }
    }
}
