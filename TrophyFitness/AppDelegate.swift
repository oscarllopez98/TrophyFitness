//
//  AppDelegate.swift
//  TrophyFitness
//
//  Created by Oscar Lopez on 1/9/25.
//

import UIKit
import Amplify

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return Amplify.Auth.signinwithweb .handleWebUISignIn(url)
    }
}
