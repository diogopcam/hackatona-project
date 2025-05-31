//
//  Feedback.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

class Feedback: Codable {
    let stars: Int
    let description: String
    let senderID: String
    let receiverID: String
    let midia: String?
    
    init(stars: Int, description: String, senderID: String, receiverID: String, midia: String?) {
        self.stars = stars
        self.description = description
        self.senderID = senderID
        self.receiverID = receiverID
        self.midia = midia
    }
}
