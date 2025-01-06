//
//  ErrorResponseModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

// Represents an error response from the API
struct ErrorResponseModel: Codable, Error {
    let message: String
}
