import Foundation

struct APIResponse<T: Codable>: Codable {
    let count: Int
    let data: [T]
} 