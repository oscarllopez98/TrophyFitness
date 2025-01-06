//
//  Workout.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

struct Workout: Codable, Identifiable {
    let id: Int
    let userId: String
    let title: String
    let description: String?
    let difficulty: Int?
    let exercises: [Exercise]
    let createdAt: Date
    let updatedAt: Date

    // Helper method to format the difficulty as a percentage
    var formattedDifficulty: String {
        guard let difficulty = difficulty else { return "N/A" }
        return "\(difficulty)%"
    }

    // Helper method to format the creation date
    var formattedCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}
