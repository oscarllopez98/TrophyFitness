//
//  ExerciseAPIManager.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

//
//  ExerciseAPIManager.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation
import Amplify
import AWSPluginsCore

class ExerciseAPIManager: ObservableObject {
    static let shared = ExerciseAPIManager()

    // Use the correct base URL based on the build configuration
    #if DEBUG
    let baseURL = (Bundle.main.infoDictionary?["BASE_URL_DEV"] as? String ?? "").replacingOccurrences(of: "&", with: "")
    #else
    let baseURL = (Bundle.main.infoDictionary?["BASE_URL_PROD"] as? String ?? "").replacingOccurrences(of: "&", with: "")
    #endif

    // MARK: - Helper to fetch the JWT token
    private func getAuthToken(completion: @escaping (String?) -> Void) {
        Task {
            do {
                let session = try await Amplify.Auth.fetchAuthSession()
                if let cognitoTokenProvider = session as? AuthCognitoTokensProvider {
                    let tokens = try cognitoTokenProvider.getCognitoTokens().get()
                    completion(tokens.idToken)
                } else {
                    completion(nil)
                }
            } catch {
                print("Failed to fetch auth session: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

    // MARK: - Create Exercise
    func createExercise(_ exercise: CreateExerciseRequestModel, completion: @escaping (Result<CreateExerciseResponseModel, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(exercise)
            request(endpoint: "/exercises", method: "POST", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: "Failed to encode request body: \(error.localizedDescription)")))
        }
    }

    // MARK: - Get Exercise by ID
    func getExerciseById(_ exerciseId: Int, completion: @escaping (Result<GetExerciseResponseModel, ErrorResponseModel>) -> Void) {
        request(endpoint: "/exercises/\(exerciseId)", method: "GET", completion: completion)
    }

    // MARK: - Update Exercise
    func updateExercise(_ exerciseId: Int, exercise: UpdateExerciseRequestModel, completion: @escaping (Result<UpdateExerciseResponseModel, ErrorResponseModel>) -> Void) {
        do {
            let body = try JSONEncoder().encode(exercise)
            request(endpoint: "/exercises/\(exerciseId)", method: "PUT", body: body, completion: completion)
        } catch {
            completion(.failure(ErrorResponseModel(message: "Failed to encode request body: \(error.localizedDescription)")))
        }
    }

    // MARK: - Delete Exercise
    func deleteExercise(exerciseId: Int, completion: @escaping (Result<DeleteExerciseResponseModel, ErrorResponseModel>) -> Void) {
        request(endpoint: "/exercises/\(exerciseId)", method: "DELETE", completion: completion)
    }

    // MARK: - Search Exercises
    func searchExercises(query: String, category: String? = nil, completion: @escaping (Result<[SearchExercisesResponseModel], ErrorResponseModel>) -> Void) {
        var endpoint = "/search?query=\(query)"
        if let category = category {
            endpoint += "&category=\(category)"
        }
        request(endpoint: endpoint, method: "GET", completion: completion)
    }

    // MARK: - Helper function for making requests
    private func request<T: Decodable>(
        endpoint: String,
        method: String,
        body: Data? = nil,
        completion: @escaping (Result<T, ErrorResponseModel>) -> Void
    ) {
        getAuthToken { token in
            guard let token = token else {
                let errorMessage = "No token available"
                print("Request failed: \(errorMessage)")
                completion(.failure(ErrorResponseModel(message: errorMessage)))
                return
            }

            guard let url = URL(string: "\(self.baseURL)\(endpoint)") else {
                let errorMessage = "Invalid URL"
                print("Request failed: \(errorMessage)")
                completion(.failure(ErrorResponseModel(message: errorMessage)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = method
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            if let body = body {
                request.httpBody = body
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    completion(.failure(ErrorResponseModel(message: error.localizedDescription)))
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    let errorMessage = "Invalid response from server"
                    print("Request failed: \(errorMessage)")
                    completion(.failure(ErrorResponseModel(message: errorMessage)))
                    return
                }

                switch httpResponse.statusCode {
                case 200...299:
                    if let data = data {
                        print("Response data: \(String(data: data, encoding: .utf8) ?? "No readable data")")
                        do {
                            let decodedBody = try JSONDecoder().decode(T.self, from: data)
                            completion(.success(decodedBody))
                        } catch {
                            print("Decoding error (success response): \(error)")
                            completion(.failure(ErrorResponseModel(message: "Failed to decode success response: \(error.localizedDescription)")))
                        }
                    } else {
                        let errorMessage = "No data received"
                        print("Request failed: \(errorMessage)")
                        completion(.failure(ErrorResponseModel(message: errorMessage)))
                    }
                case 400...499:
                    if let data = data {
                        print("Client error response: \(String(data: data, encoding: .utf8) ?? "No readable data")")
                        do {
                            let errorResponse = try JSONDecoder().decode(ErrorResponseModel.self, from: data)
                            completion(.failure(errorResponse))
                        } catch {
                            print("Decoding error (client error): \(error)")
                            completion(.failure(ErrorResponseModel(message: "Client error: \(httpResponse.statusCode)")))
                        }
                    } else {
                        let errorMessage = "Client error: \(httpResponse.statusCode)"
                        print("Request failed: \(errorMessage)")
                        completion(.failure(ErrorResponseModel(message: errorMessage)))
                    }
                case 500...599:
                    let errorMessage = "Server error: \(httpResponse.statusCode)"
                    print("Request failed: \(errorMessage)")
                    completion(.failure(ErrorResponseModel(message: errorMessage)))
                default:
                    let errorMessage = "Unexpected status code: \(httpResponse.statusCode)"
                    print("Request failed: \(errorMessage)")
                    completion(.failure(ErrorResponseModel(message: errorMessage)))
                }
            }.resume()
        }
    }

}
