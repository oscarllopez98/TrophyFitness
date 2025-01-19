//
//  ContentView.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 12/31/24.
//

import SwiftUI
//import Authenticator

struct ContentView: View {
    var body: some View {
//        Authenticator { state in
//            if state.isSignedIn {
//                HomeView()
//            } else {
//                WelcomeView()
//            }
//        }
        WelcomeView()
    }
}

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to TrophyFitness!")
                .font(.largeTitle)
                .padding()

            Text("Please sign in or sign up to continue.")
                .padding()
        }
    }
}

#Preview {
    ContentView()
}
