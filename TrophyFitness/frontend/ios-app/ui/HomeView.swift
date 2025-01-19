//
//  HomeView.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/7/25.
//

import SwiftUI

import SwiftUI

struct HomeView: View {
    @State private var message: String = ""
    @State private var exerciseIdInput: String = ""
    @State private var queryInput: String = ""
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("TrophyFitness")
                .font(.largeTitle)
                .padding()

            // Dynamic message display
            Text(message)
                .foregroundColor(message.contains("Error") ? .red : .green)
                .padding()

            // Input for Exercise ID
            TextField("Enter Exercise ID", text: $exerciseIdInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.horizontal)

            // Input for Search Query
            TextField("Enter Search Query", text: $queryInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Buttons for API Calls
            Group {
                Button("Create Sample Exercise") {
                    createExercise()
                }
                .buttonStyle(ActionButtonStyle())

                Button("Get Exercise by ID") {
                    if let exerciseId = Int(exerciseIdInput) {
                        getExerciseById(exerciseId)
                    } else {
                        message = "Invalid Exercise ID"
                    }
                }
                .buttonStyle(ActionButtonStyle())

                Button("Update Exercise") {
                    if let exerciseId = Int(exerciseIdInput) {
                        updateExercise(exerciseId)
                    } else {
                        message = "Invalid Exercise ID"
                    }
                }
                .buttonStyle(ActionButtonStyle())

                Button("Delete Exercise") {
                    if let exerciseId = Int(exerciseIdInput) {
                        deleteExercise(exerciseId)
                    } else {
                        message = "Invalid Exercise ID"
                    }
                }
                .buttonStyle(ActionButtonStyle())

                Button("Search Exercises") {
                    searchExercises(query: queryInput)
                }
                .buttonStyle(ActionButtonStyle())
            }
            Spacer()

            // Sign Out Button
            Button("Sign Out") {
                Task {
                    await authViewModel.signOut()
                }
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }

    // MARK: - Create Exercise
    private func createExercise() {
        let sampleExercise = CreateExerciseRequestModel(name: "Push Up", category: "Strength", sets: 10, reps: 10, duration: 30)
        ExerciseAPIManager.shared.createExercise(sampleExercise) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    message = "\(response.message) with ID: \(response.exerciseId)"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    message = "Error: \(error.message)"
                }
            }
        }
    }

    // MARK: - Get Exercise by ID
    private func getExerciseById(_ exerciseId: Int) {
        ExerciseAPIManager.shared.getExerciseById(exerciseId) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    message = "Exercise: \(response.name), Category: \(response.category)"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    message = "Error: \(error.message)"
                }
            }
        }
    }

    // MARK: - Update Exercise
    private func updateExercise(_ exerciseId: Int) {
        let updatedExercise = UpdateExerciseRequestModel(name: "Updated Push Up", category: "Strength", sets: 12, reps: 15, duration: 20)
        ExerciseAPIManager.shared.updateExercise(exerciseId, exercise: updatedExercise) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    if let exerciseIdInt = response.exerciseIdInt {
                        message = "\(response.message) with ID: \(exerciseIdInt)"
                    } else {
                        message = "\(response.message) with an unknown ID"
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    message = "Error: \(error.message)"
                }
            }
        }
    }


    // MARK: - Delete Exercise
    private func deleteExercise(_ exerciseId: Int) {
        ExerciseAPIManager.shared.deleteExercise(exerciseId: exerciseId) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    message = response.message
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    message = "Error: \(error.message)"
                }
            }
        }
    }

    // MARK: - Search Exercises
    private func searchExercises(query: String) {
        ExerciseAPIManager.shared.searchExercises(query: query) { result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    message = "Found \(response.count) exercises"
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    message = "Error: \(error.message)"
                }
            }
        }
    }
}

// MARK: - Button Style
struct ActionButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(maxWidth: .infinity)
            .background(configuration.isPressed ? Color.blue.opacity(0.7) : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
    }
}
