//
//  TrophyFitnessApp.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 12/31/24.
//

import Amplify
import Authenticator
import AWSCognitoAuthPlugin
import SwiftUI

@main
struct TrophyFitnessApp: App {
    init() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            try Amplify.configure(with: .amplifyOutputs)
        } catch {
            print("Unable to configure Amplify \(error)")
        }
    }

    var body: some Scene {
        WindowGroup {
            Authenticator { state in
                VStack {
                    Text("Hello, \(state.user.username)")
                    Button("Sign out") {
                        Task {
                            await state.signOut()
                        }
                    }
                }
            }
        }
    }
}
