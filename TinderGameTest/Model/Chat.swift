//
//  Chat.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import Foundation

struct Chat: Identifiable {
    let id = UUID()
    let name: String
    let lastMessage: String
    let imageName: String
    let isVerified: Bool
    let gameInvite: Bool
}
