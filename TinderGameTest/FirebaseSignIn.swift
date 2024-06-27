//
//  FirebaseSignIn.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/26/24.
//

import Foundation

func signInAnonymous() async throws {
    let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
//    let user = DBUser(auth: authDataResult)
//    try await UserManager.shared.createNewUser(user: user)
}
