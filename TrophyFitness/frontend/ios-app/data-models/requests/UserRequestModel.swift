//
//  UserRequestModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/2/25.
//

import Foundation

// Request model for creating a new user
struct CreateUserRequestModel: Codable {
    let email: String
    let password: String
    let birthdate: String
    let phoneNumber: String
    let firstName: String
    let lastName: String
}

// Request model for updating a user's profile
struct UpdateUserRequestModel: Codable {
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let birthdate: String?
}

// Request model for deleting a user account
struct DeleteUserRequestModel: Codable {
    let userId: String
}
