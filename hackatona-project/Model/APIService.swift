//
//  APIService.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import UIKit

enum NetworkError: Error {
    case invalidURL
    case requestFailed(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
}

class APIService {
    static let shared = APIService(baseURL: URL(string: "https://seu-backend.com/api/")!)
    private let baseURL: URL
    
    private let decoder: JSONDecoder = {
        let dec = JSONDecoder()
        dec.dateDecodingStrategy = .iso8601
        return dec
    }()
    
    private let encoder: JSONEncoder = {
        let enc = JSONEncoder()
        enc.dateEncodingStrategy = .iso8601
        return enc
    }()

    private init(baseURL: URL) {
        self.baseURL = baseURL
    }

    private func request<T: Decodable>(
        _ path: String,
        httpMethod: String = "GET",
        body: Data? = nil
    ) async throws -> T {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        if let bodyData = body {
            request.httpBody = bodyData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            let code = (response as? HTTPURLResponse)?.statusCode ?? -1
            throw NetworkError.requestFailed(statusCode: code)
        }

        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
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
}
