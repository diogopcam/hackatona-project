import Foundation

struct EmployeeStats: Codable {
    let employeeID: String
    let totalFeedbacks: Int
    let averageRating: Double
    let feedbacksReceived: Int
    let feedbacksSent: Int
    let lastFeedbackDate: Date?
    
    enum CodingKeys: String, CodingKey {
        case employeeID = "employee_id"
        case totalFeedbacks = "total_feedbacks"
        case averageRating = "average_rating"
        case feedbacksReceived = "feedbacks_received"
        case feedbacksSent = "feedbacks_sent"
        case lastFeedbackDate = "last_feedback_date"
    }
} 