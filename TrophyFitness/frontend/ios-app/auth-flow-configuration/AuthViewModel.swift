//
//  AuthViewModel.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import Foundation
import Amplify

class AuthViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false

    init() {
        Task {
            await fetchAuthSession()
        }
    }

    // Fetch the current authentication session
    func fetchAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            DispatchQueue.main.async {
                self.isSignedIn = session.isSignedIn
            }
        } catch {
            print("Failed to fetch auth session: \(error.localizedDescription)")
        }
    }

    // Sign out the user
    func signOut() async {
        do {
            try await Amplify.Auth.signOut()
            DispatchQueue.main.async {
                self.isSignedIn = false
            }
        } catch {
            print("Sign out failed: \(error.localizedDescription)")
        }
    }
}
