//
//  AuthView.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import SwiftUI
import Amplify

struct AuthView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    @State private var isSignedIn = false

    var body: some View {
        if isSignedIn {
            let _ = print("hi!")
            HomeView()
        } else {
            VStack {
                Text("Sign In")
                    .font(.largeTitle)
                    .padding()

                TextField("Email or Phone", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button(action: {
                    Task {
                        await signIn()
                    }
                }) {
                    Text("Sign In")
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
    }

    private func signIn() async {
        do {
            let signInResult = try await Amplify.Auth.signIn(username: email, password: password)
            if signInResult.isSignedIn {
                DispatchQueue.main.async {
                    isSignedIn = true
                    errorMessage = "Sign in succeeded!"
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Confirmation required."
                }
            }
        } catch {
            DispatchQueue.main.async {
                errorMessage = "Sign in failed: \(error.localizedDescription)"
            }
        }
    }
}


struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
    }
}
