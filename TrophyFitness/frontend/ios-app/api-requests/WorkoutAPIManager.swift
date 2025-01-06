//
//  WorkoutAPIManager.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

class WorkoutAPIManager {
    static let shared = WorkoutAPIManager()

    #if DEBUG
    let baseURL = Bundle.main.infoDictionary?["BASE_URL_DEV"] as? String ?? ""
    #else
    let baseURL = Bundle.main.infoDictionary?["BASE_URL_PROD"] as? String ?? ""
    #endif

    // MARK: - Create Workout
    func createWorkout(_ workout: CreateWorkoutRequestModel, completion: @escaping (Result<VoidResponse, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(workout)
            request(endpoint: "/workouts", method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: error.localizedDescription)))
        }
    }

    // MARK: - Get Workouts for User
    func getWorkoutsForUser(userId: String, completion: @escaping (Result<[WorkoutResponseModel], ErrorResponseModel>) -> Void) {
        request(endpoint: "/users/\(userId)/workouts", method: "GET", completion: completion)
    }

    // MARK: - Update Workout
    func updateWorkout(_ workoutId: String, workout: UpdateWorkoutRequestModel, completion: @escaping (Result<VoidResponse, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(workout)
            request(endpoint: "/workouts/\(workoutId)", method: "PUT", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: error.localizedDescription)))
        }
    }

    // MARK: - Delete Workout
    func deleteWorkout(workoutId: String, completion: @escaping (Result<VoidResponse, ErrorResponseModel>) -> Void) {
        request(endpoint: "/workouts/\(workoutId)", method: "DELETE", completion: completion)
    }

    // MARK: - Add Exercise to Workout
    func addExerciseToWorkout(_ requestModel: AddExerciseToWorkoutRequestModel, completion: @escaping (Result<VoidResponse, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(requestModel)
            request(endpoint: "/workouts/\(requestModel.workoutId)/exercises", method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: error.localizedDescription)))
        }
    }

    // MARK: - Helper function for making requests
    private func request<T: Codable>(endpoint: String, method: String, body: Data? = nil, completion: @escaping (Result<T, ErrorResponseModel>) -> Void) {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(ErrorResponseModel(message: "Invalid URL")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add Authorization header
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = body
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(ErrorResponseModel(message: error.localizedDescription)))
                return
            }

            guard let data = data else {
                completion(.failure(ErrorResponseModel(message: "No data received from the server")))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                do {
                    let errorResponse = try JSONDecoder().decode(ErrorResponseModel.self, from: data)
                    completion(.failure(errorResponse))
                } catch {
                    completion(.failure(ErrorResponseModel(message: "Failed to decode the server response")))
                }
            }
        }.resume()
    }
}
