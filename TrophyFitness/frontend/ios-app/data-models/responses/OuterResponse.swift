//
//  OuterResponse.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/7/25.
//

import Foundation

// Outer response struct for Lambda responses
struct OuterResponse: Codable {
    let statusCode: Int
    let body: String
}
