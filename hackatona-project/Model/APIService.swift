//
//  APIService.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit
import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .requestFailed(let statusCode):
            return "Falha na requisição: Status \(statusCode)"
        case .decodingError(let error):
            return "Erro ao decodificar resposta: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Erro ao codificar dados: \(error.localizedDescription)"
        case .networkError(let error):
            return "Erro de rede: \(error.localizedDescription)"
        }
    }
}

class APIService {
    static let shared = APIService()
    private let baseURL: URL
    
    private let decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.keyDecodingStrategy = .useDefaultKeys
        return dec
    }()
    
    private let encoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.keyEncodingStrategy = .useDefaultKeys
        return enc
    }()
    
    private init() {
        guard let url = URL(string: APIEndpoints.baseURL) else {
            fatalError("Invalid base URL")
        }
        self.baseURL = url
    }
    
    private func request<T: Codable>(
        _ path: String,
        httpMethod: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        let urlString = baseURL.absoluteString.trimmingCharacters(in: CharacterSet(charactersIn: "/")) + "/" + path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            throw NetworkError.invalidURL
        }
        
        print("Requesting URL: \(url.absoluteString)")
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        if let bodyData = body {
            request.httpBody = bodyData
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            print("Response received: \(String(data: data, encoding: .utf8) ?? "No data")")
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.requestFailed(statusCode: -1)
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                print("HTTP Error: \(httpResponse.statusCode)")
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
            }
            
            do {
                return try decoder.decode(T.self, from: data)
            } catch {
                print("Decoding error: \(error)")
                throw NetworkError.decodingError(error)
            }
        } catch {
            if let networkError = error as? NetworkError {
                throw networkError
            }
            throw NetworkError.networkError(error)
        }
    }
    
    func fetchResources() async throws -> [Resource] {
        try await request("resources")
    }

    func fetchEmployee(byID id: String) async throws -> Employee {
        try await request("employees/\(id)")
    }

    func fetchActivities() async throws -> [Activity] {
        try await request("activities")
    }

    func createFeedback(_ feedback: Feedback) async throws -> Feedback {
        let path = "feedbacks"
        let bodyData: Data
        do {
            bodyData = try encoder.encode(feedback)
        } catch {
            throw NetworkError.encodingError(error)
        }
        return try await request(path, httpMethod: "POST", body: bodyData)
    }
    
    func fetchBenefits(_ benefitID: Benefit) async throws -> [Benefit] {
        let path = "benefits/\(benefitID)"
        
        return try await request(path, httpMethod: "GET")
    }
    
    func fetchAllBenefits() async throws -> [Benefit] {
        let path = "benefits"
        return try await request(path, httpMethod: "GET")
    }

    // MARK: - Employee Endpoints
    func getAllEmployees() async throws -> [Employee] {
        let response: APIResponse<Employee> = try await request(APIEndpoints.Employees.getAll)
        return response.data
    }
    
    func getEmployeeRanking() async throws -> [Employee] {
        let response: APIResponse<Employee> = try await request(APIEndpoints.Employees.ranking)
        return response.data
    }
    
    func getEmployeeByID(_ id: String) async throws -> Employee {
        let response: APIResponse<Employee> = try await request(APIEndpoints.Employees.byID + id)
        return response.data[0]
    }
    
    func getEmployeesByPosition(_ position: String) async throws -> [Employee] {
        let response: APIResponse<Employee> = try await request(APIEndpoints.Employees.byPosition + position)
        return response.data
    }
    
    func createEmployee(_ employee: Employee) async throws -> Employee {
        let path = APIEndpoints.Employees.create
        let bodyData = try encoder.encode(employee)
        let response: APIResponse<Employee> = try await request(path, httpMethod: "POST", body: bodyData)
        return response.data[0]
    }
    
    func updateEmployee(_ id: String, employee: Employee) async throws -> Employee {
        let path = APIEndpoints.Employees.update + id
        let bodyData = try encoder.encode(employee)
        let response: APIResponse<Employee> = try await request(path, httpMethod: "PUT", body: bodyData)
        return response.data[0]
    }
    
    func deleteEmployee(_ id: String) async throws {
        _ = try await request(APIEndpoints.Employees.delete + id, httpMethod: "DELETE") as EmptyResponse
    }
    
    // MARK: - Feedback Endpoints
    func getAllFeedbacks() async throws -> [Feedback] {
        let response: APIResponse<Feedback> = try await request(APIEndpoints.Feedbacks.getAll)
        return response.data
    }
    
    func getFeedbackByID(_ id: String) async throws -> Feedback {
        let response: APIResponse<Feedback> = try await request(APIEndpoints.Feedbacks.byID + id)
        return response.data[0]
    }

    
    func getFeedbacksByReceiver(_ id: String) async throws -> [Feedback] {
        let response: APIResponse<Feedback> = try await request(APIEndpoints.Feedbacks.byReceiver + id)
        return response.data
    }
    
    func getFeedbacksBySender(_ id: String) async throws -> [Feedback] {
        let response: APIResponse<Feedback> = try await request(APIEndpoints.Feedbacks.bySender + id)
        return response.data
    }
    
    func getEmployeeStats(_ id: String) async throws -> EmployeeStats {
        let response: APIResponse<EmployeeStats> = try await request(APIEndpoints.Feedbacks.stats + id)
        return response.data[0]
    }
    
    // MARK: - Resource Endpoints
    func getAllResources() async throws -> [Resource] {
        let response: APIResponse<Resource> = try await request(APIEndpoints.Resources.getAll)
        return response.data
    }
    
    func getResourceByID(_ id: String) async throws -> Resource {
        let response: APIResponse<Resource> = try await request(APIEndpoints.Resources.byID + id)
        return response.data[0]
    }
    
    func createResource(_ resource: Resource) async throws -> Resource {
        let path = APIEndpoints.Resources.create
        let bodyData = try encoder.encode(resource)
        let response: APIResponse<Resource> = try await request(path, httpMethod: "POST", body: bodyData)
        return response.data[0]
    }
    
    func updateResource(_ id: String, resource: Resource) async throws -> Resource {
        let path = APIEndpoints.Resources.update + id
        let bodyData = try encoder.encode(resource)
        let response: APIResponse<Resource> = try await request(path, httpMethod: "PUT", body: bodyData)
        return response.data[0]
    }
    
    func getResourcesByType(_ type: String) async throws -> [Resource] {
        let response: APIResponse<Resource> = try await request(APIEndpoints.Resources.byType + type)
        return response.data
    }
    
    // MARK: - Activity Endpoints
    func getAllActivities() async throws -> [Activity] {
        let response: APIResponse<Activity> = try await request(APIEndpoints.Activities.getAll)
        return response.data
    }
    
    func getActivityByID(_ id: String) async throws -> Activity {
        let response: APIResponse<Activity> = try await request(APIEndpoints.Activities.byID + id)
        return response.data[0]
    }
    
    func createActivity(_ activity: Activity) async throws -> Activity {
        let path = APIEndpoints.Activities.create
        let bodyData = try encoder.encode(activity)
        let response: APIResponse<Activity> = try await request(path, httpMethod: "POST", body: bodyData)
        return response.data[0]
    }
    
    // Helper struct for empty responses
    private struct EmptyResponse: Codable {}
}
