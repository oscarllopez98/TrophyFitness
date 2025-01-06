//
//  ExerciseResponseModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

// Represents a single exercise fetched from the API
struct ExerciseResponseModel: Codable {
    let id: Int
    let name: String
    let category: String
    let sets: Int
    let reps: Int
    let duration: Int?
    let createdAt: String
    let updatedAt: String
}
