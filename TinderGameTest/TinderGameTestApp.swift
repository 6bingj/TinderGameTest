//
//  TinderGameTestApp.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI
import FirebaseCore

@main
struct TinderGameTestApp: App {
    
    init() {
        FirebaseApp.configure()
        print("Configured Firebase")
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    do {
                        try await signInAnonymous()
                    } catch {
                        print(error)
                    }
                }
        }
    }
}
