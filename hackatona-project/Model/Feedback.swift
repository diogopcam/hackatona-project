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
    let senderName: String?
    let senderPosition: String?
    let senderPhoto: String?
    let receiverName: String?
    let receiverPosition: String?
    let receiverPhoto: String?
    
    init(stars: Int, description: String, senderID: String, receiverID: String, midia: String?,
         senderName: String? = nil, senderPosition: String? = nil, senderPhoto: String? = nil,
         receiverName: String? = nil, receiverPosition: String? = nil, receiverPhoto: String? = nil) {
        self.stars = stars
        self.description = description
        self.senderID = senderID
        self.receiverID = receiverID
        self.midia = midia
        self.senderName = senderName
        self.senderPosition = senderPosition
        self.senderPhoto = senderPhoto
        self.receiverName = receiverName
        self.receiverPosition = receiverPosition
        self.receiverPhoto = receiverPhoto
    }
}
