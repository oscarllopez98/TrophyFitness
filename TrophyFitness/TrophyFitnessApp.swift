//
//  TrophyFitnessApp.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 12/31/24.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

@main
struct TrophyFitnessApp: App {
    // App state to track if the user is signed in
    @StateObject private var authViewModel = AuthViewModel()

    init() {
        configureAmplify()
    }

    var body: some Scene {
        WindowGroup {
            if authViewModel.isSignedIn {
                HomeView() // Main app content
            } else {
                AuthView() // Custom sign-in/signup view
            }
        }
    }

    /// Configures Amplify with the necessary plugins.
    private func configureAmplify() {
        do {
            // Add Cognito Auth Plugin
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            
            // Configure Amplify
            try Amplify.configure()
            
            print("Amplify configured successfully")
        } catch {
            print("Failed to configure Amplify: \(error.localizedDescription)")
        }
    }
}
