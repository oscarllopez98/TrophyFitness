//
//  Exercise.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

struct Exercise: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let sets: Int
    let reps: Int
    let duration: Int?
    let createdAt: Date
    let updatedAt: Date

    // Helper method to format sets and reps as a string
    var setsAndReps: String {
        return "\(sets) sets of \(reps) reps"
    }

    // Helper method to format duration if available
    var formattedDuration: String {
        guard let duration = duration else { return "No duration set" }
        return "\(duration) minutes"
    }

    // Helper method to format the creation date
    var formattedCreatedAt: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}
