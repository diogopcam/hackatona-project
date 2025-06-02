//
//  APIResponse.swift
//  hackatona-project
//
//  Created by Marcos on 31/05/25.
//

import Foundation

struct APIResponse<T: Codable>: Codable {
    let count: Int
    let data: [T]
} 
