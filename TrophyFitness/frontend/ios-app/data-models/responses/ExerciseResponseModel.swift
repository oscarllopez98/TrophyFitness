//
//  ExerciseResponseModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

// MARK: - Create Exercise Response
struct CreateExerciseResponseModel: Codable {
    let message: String
    let exerciseId: Int
}

// MARK: - Get Exercise Response
struct GetExerciseResponseModel: Codable {
    let id: Int
    let name: String
    let category: String
    let sets: Int
    let reps: Int
    let duration: Int?
    let createdAt: String
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case sets
        case reps
        case duration
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Delete Exercise Response
struct DeleteExerciseResponseModel: Codable {
    let message: String
}

// MARK: - Update Exercise Response
struct UpdateExerciseResponseModel: Codable {
    let message: String
    let exerciseId: String

    var exerciseIdInt: Int? {
        return Int(exerciseId)
    }
}


// MARK: - Search Exercises Response
struct SearchExercisesResponseModel: Codable {
    let id: Int
    let name: String
    let category: String
    let sets: Int
    let reps: Int
    let duration: Int?
    let createdAt: String
    let updatedAt: String
}
