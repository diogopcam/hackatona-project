//
//  FeedbackManager.swift
//  hackatona-project
//
//  Created by Diogo Camargo on 31/05/25.
//
import UIKit

class FeedbackManager {
    static let shared = FeedbackManager()
    private let userDefaults = UserDefaults.standard
    private let feedbacksKey = "savedFeedbacks"
    
    func saveFeedback(_ feedback: Feedback, audioData: Data? = nil) {
        var savedFeedbacks = getFeedbacks()
        savedFeedbacks.append(feedback)
        
        if let audioData = audioData, let midia = feedback.midia {
            saveAudioFile(data: audioData, fileName: midia)
        }
        
        if let encoded = try? JSONEncoder().encode(savedFeedbacks) {
            userDefaults.set(encoded, forKey: feedbacksKey)
        }
    }
    
    func getFeedbacks(forUserID userId: String) -> [Feedback] {
        return getFeedbacks().filter { $0.receiverID == userId }
    }
    
    private func getFeedbacks() -> [Feedback] {
        guard let data = userDefaults.data(forKey: feedbacksKey),
              let feedbacks = try? JSONDecoder().decode([Feedback].self, from: data) else {
            return []
        }
        return feedbacks
    }
    
    private func saveAudioFile(data: Data, fileName: String) {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(fileName)
        try? data.write(to: fileURL)
    }
}
