//
//  Feedback.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//
import UIKit

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
    
    // Helper para obter URL do áudio
       func getAudioURL() -> URL? {
           guard let midia = midia else { return nil }
           return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
               .appendingPathComponent(midia)
       }
}
