//
//  ExerciseRequestModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/2/25.
//

import Foundation

// Request model for creating a new exercise
struct CreateExerciseRequestModel: Codable {
    let name: String
    let category: String
    let sets: Int
    let reps: Int
    let duration: Int?
}

// Request model for updating an existing exercise
struct UpdateExerciseRequestModel: Codable {
    let name: String?
    let category: String?
    let sets: Int?
    let reps: Int?
    let duration: Int?
}

// Request model for deleting an exercise
struct DeleteExerciseRequestModel: Codable {
    let exerciseId: String
}

// Request model for searching exercises by name or category
struct SearchExerciseRequestModel: Codable {
    let query: String
    let category: String?
}
