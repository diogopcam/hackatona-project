import Foundation

enum APIEndpoints {
    static let baseURL = "http://localhost:8080/api/v1"
    
    enum Employees {
        static let getAll = "/employees"
        static let ranking = "/employees/ranking"
        static let byID = "/employees/"
        static let byPosition = "/employees/position/"
        static let create = "/employees"
        static let update = "/employees/"
        static let delete = "/employees/"
    }
    
    enum Feedbacks {
        static let getAll = "/feedbacks"
        static let byID = "/feedbacks/"
        static let create = "/feedbacks"
        static let byReceiver = "/feedbacks/receiver/"
        static let bySender = "/feedbacks/sender/"
        static let stats = "/feedbacks/stats/"
    }
    
    enum Resources {
        static let getAll = "/resources"
        static let byID = "/resources/"
        static let create = "/resources"
        static let update = "/resources/"
        static let byType = "/resources/type/"
    }
    
    enum Activities {
        static let getAll = "/activities"
        static let byID = "/activities/"
        static let create = "/activities"
    }
} 
