//
//  ExerciseAPIManager.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation

class ExerciseAPIManager {
    static let shared = ExerciseAPIManager()

    #if DEBUG
    let baseURL = Bundle.main.infoDictionary?["BASE_URL_DEV"] as? String ?? ""
    #else
    let baseURL = Bundle.main.infoDictionary?["BASE_URL_PROD"] as? String ?? ""
    #endif

    // MARK: - Create Exercise
    func createExercise(_ exercise: CreateExerciseRequestModel, completion: @escaping (Result<ExerciseResponseModel, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(exercise)
            request(endpoint: "/exercises", method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: "Failed to encode request body: \(error.localizedDescription)")))
        }
    }

    // MARK: - Get Exercise by ID
    func getExerciseById(_ exerciseId: Int, completion: @escaping (Result<ExerciseResponseModel, ErrorResponseModel>) -> Void) {
        request(endpoint: "/exercises/\(exerciseId)", method: "GET", completion: completion)
    }

    // MARK: - Update Exercise
    func updateExercise(_ exerciseId: Int, exercise: UpdateExerciseRequestModel, completion: @escaping (Result<VoidResponse, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(exercise)
            request(endpoint: "/exercises/\(exerciseId)", method: "PUT", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: "Failed to encode request body: \(error.localizedDescription)")))
        }
    }

    // MARK: - Delete Exercise
    func deleteExercise(exerciseId: Int, completion: @escaping (Result<VoidResponse, ErrorResponseModel>) -> Void) {
        request(endpoint: "/exercises/\(exerciseId)", method: "DELETE", completion: completion)
    }

    // MARK: - Search Exercises
    func searchExercises(query: String, category: String? = nil, completion: @escaping (Result<[ExerciseResponseModel], ErrorResponseModel>) -> Void) {
        var endpoint = "/search?query=\(query)"
        if let category = category {
            endpoint += "&category=\(category)"
        }
        request(endpoint: endpoint, method: "GET", completion: completion)
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
