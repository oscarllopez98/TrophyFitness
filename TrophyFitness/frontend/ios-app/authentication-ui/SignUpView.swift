//
//  SignUpView.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/6/25.
//

import SwiftUI
import Amplify

struct SignUpView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var phoneNumber: String = ""
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .padding()

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("Phone Number", text: $phoneNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.phonePad)
                .padding()

            Button(action: {
                Task {
                    await signUp()
                }
            }) {
                Text("Sign Up")
                    .padding()
                    .background(Color.green)
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

    private func signUp() async {
        let userAttributes = [
            AuthUserAttribute(.email, value: email),
            AuthUserAttribute(.phoneNumber, value: phoneNumber)
        ]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)

        do {
            let signUpResult = try await Amplify.Auth.signUp(
                username: email,
                password: password,
                options: options
            )

            if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                DispatchQueue.main.async {
                    errorMessage = "Confirmation needed. Delivery details: \(String(describing: deliveryDetails)). User ID: \(String(describing: userId))."
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Sign-up complete!"
                }
            }
        } catch let error as AuthError {
            DispatchQueue.main.async {
                errorMessage = "An error occurred while registering a user: \(error.localizedDescription)"
            }
        } catch {
            DispatchQueue.main.async {
                errorMessage = "Unexpected error: \(error.localizedDescription)"
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
