import Foundation

enum APIEndpoints {
    static let baseURL = "https://a653-2804-18-196e-1a59-9a-d7ae-b9c-6e62.ngrok-free.app/api/v1"
    
    
    enum Employees {
        static let getAll = "/employees"
        static let ranking = "/employees/ranking"
        static let byID = "/employees/" // append ID
        static let byPosition = "/employees/position/" // append position
        static let create = "/employees"
        static let update = "/employees/" // append ID
        static let delete = "/employees/" // append ID
    }
    
    enum Feedbacks {
        static let getAll = "/feedbacks"
        static let byID = "/feedbacks/" // append ID
        static let create = "/feedbacks"
        static let byReceiver = "/feedbacks/receiver/" // append ID
        static let bySender = "/feedbacks/sender/" // append ID
        static let stats = "/feedbacks/stats/" // append ID
    }
    
    enum Resources {
        static let getAll = "/resources"
        static let byID = "/resources/" // append ID
        static let create = "/resources"
        static let update = "/resources/" // append ID
        static let byType = "/resources/type/" // append type
    }
    
    enum Activities {
        static let getAll = "/activities"
        static let byID = "/activities/" // append ID
        static let create = "/activities"
    }
} 
