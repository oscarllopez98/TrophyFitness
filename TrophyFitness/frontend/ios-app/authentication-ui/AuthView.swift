//
//  AuthView.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import SwiftUI
import Amplify

struct AuthView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            Text("Welcome to TrophyFitness")
                .font(.largeTitle)
                .padding()

            Button(action: {
                Task {
                    print("1")
                    await signInWithHostedUI()
                    print("2")
                }
            }) {
                Text("Sign In / Sign Up")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()

            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }

    private func signInWithHostedUI() async {
        print("Click")

        // Safely get the presentation anchor for iOS 15+
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            errorMessage = "Failed to get window scene."
            print("❌ Error: windowScene is nil.")
            return
        }
        print("Click 2")

        guard let window = windowScene.windows.first else {
            errorMessage = "Failed to get window."
            print("❌ Error: window is nil.")
            return
        }
        print("Click 3")

        do {
            print("Click 3.5")
            // Launch the Hosted UI
            let result = try await Amplify.Auth.signInWithWebUI(presentationAnchor: window)
            print("Click 3.6")
            print("✅ Hosted UI result: \(result)")

            if result.isSignedIn {
                DispatchQueue.main.async {
                    authViewModel.isSignedIn = true
                }
                print("✅ User successfully signed in.")
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Sign-in failed. Please try again."
                }
                print("❌ Sign-in failed. Please try again.")
            }
        } catch let authError as AuthError {
            print("❌ AuthError: \(authError)")
            DispatchQueue.main.async {
                errorMessage = "Sign-in failed: \(authError.errorDescription). \(authError.recoverySuggestion)"
            }
        } catch {
            print("❌ Unexpected error: \(error.localizedDescription)")
            DispatchQueue.main.async {
                errorMessage = "Sign-in failed: \(error.localizedDescription)"
            }
        }
        print("Click 4")

    }


}



struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
