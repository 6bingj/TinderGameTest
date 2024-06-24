//
//  MessageHandling.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

class MessageHandling {
    static func sendMessage(_ message: String, role: MessageRole, conversation: inout Conversation) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        conversation.messages.append(newMessage)
        
        if role == .userPrompt {
            if let level = levels[currentLevel] {
                currentLevel = level.correctOption //update level
                let description = levels[currentLevel]?.description ?? "" //get the new level description
                let aiMessage = Message(id: UUID().uuidString, role: .host, content: description, createdAt: Date())
                conversation.messages.append(aiMessage)
            } else {
                let errorMessage = Message(id: UUID().uuidString, role: .host, content: "I didn't understand that. Please try again.", createdAt: Date())
                conversation.messages.append(errorMessage)
            }
        } else if role == .user {
            let matchResponse = "Thanks for your input. Let's see what happens next."
            let matchMessage = Message(id: UUID().uuidString, role: .match, content: matchResponse, createdAt: Date())
            conversation.messages.append(matchMessage)
        }
    }
}
