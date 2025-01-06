//
//  APIManager.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/4/25.
//

import Foundation

class APIManager {
    static let shared = APIManager()

    // Use the correct base URL based on the build configuration
    #if DEBUG
    let baseURL = Bundle.main.infoDictionary?["BASE_URL_DEV"] as? String ?? ""
    #else
    let baseURL = Bundle.main.infoDictionary?["BASE_URL_PROD"] as? String ?? ""
    #endif

    func request<T: Codable>(
        endpoint: String,
        method: String,
        body: Data? = nil,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        
        print("Base URL: \(baseURL)")

        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Add your JWT token from UserDefaults
        if let token = UserDefaults.standard.string(forKey: "token") {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            request.httpBody = body
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data"])))
                return
            }

            do {
                let decodedResponse = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
