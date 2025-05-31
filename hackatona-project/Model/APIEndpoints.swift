import Foundation

enum APIEndpoints {
    static let baseURL = "http://localhost:8080/api/v1"
    
    enum Employees {
        static let getAll = "/employees"
        static let ranking = "/employees/ranking"
        static let byID = "/employees/" // append ID
        static let byPosition = "/employees/position/" // append position
    }
    
    enum Feedbacks {
        static let getAll = "/feedbacks"
        static let byID = "/feedbacks/" // append ID
        static let byReceiver = "/feedbacks/receiver/" // append ID
        static let bySender = "/feedbacks/sender/" // append ID
        static let stats = "/feedbacks/stats/" // append ID
    }
    
    enum Activities {
        static let getAll = "/activities"
        static let byID = "/activities/" // append ID
    }
} 
