//
//  WorkoutResponseModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

// Represents a single workout fetched from the API
struct WorkoutResponseModel: Codable {
    let id: Int
    let userId: String
    let title: String
    let description: String?
    let difficulty: Int?
    let createdAt: String
    let updatedAt: String
    let exercises: [CreateExerciseResponseModel]
}
