//
//  Feedback.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

struct Feedback: Codable {
    let stars: Int
    let description: String
    let senderID: String
    let receiverID: String
    let midia: String?
}
