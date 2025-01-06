//
//  WorkoutRequestModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/2/25.
//

import Foundation

// Request model for creating a new workout
struct CreateWorkoutRequestModel: Codable {
    let userId: String
    let title: String
    let description: String?
    let difficulty: Int?
    let exercises: [CreateExerciseRequestModel]
}

// Request model for updating a workout
struct UpdateWorkoutRequestModel: Codable {
    let title: String?
    let description: String?
    let difficulty: Int?
    let exercises: [UpdateExerciseRequestModel]?
}

// Request model for deleting a workout
struct DeleteWorkoutRequestModel: Codable {
    let workoutId: String
}

// Request model for adding an exercise to a workout
struct AddExerciseToWorkoutRequestModel: Codable {
    let workoutId: String
    let exerciseId: String
    let sets: Int
    let reps: Int
    let duration: Int?
}

// Request model for searching workouts by name or type
struct SearchWorkoutRequestModel: Codable {
    let query: String
    let type: String?
}
