//
//  MessageHandling.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

class MessageHandling {
    
    static func sendMessage(_ message: String, role: MessageRole, conversation: inout Conversation, currentLevel: inout String) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        conversation.messages.append(newMessage)
        
        if role == .userPrompt {
            if let level = levels[currentLevel] { // User selected correct prompt, level up
                currentLevel = level.correctOption // Update level
                if let newLevel = levels[currentLevel] {
                    // Add Host's description message
                    let aiMessage = Message(id: UUID().uuidString, role: .host, content: newLevel.description, createdAt: Date())
                    conversation.messages.append(aiMessage)
                    
                    // Add Match's follow-up messages
                    for followUp in newLevel.matchMessages {
                        let matchMessage = Message(id: UUID().uuidString, role: .match, content: followUp, createdAt: Date())
                        conversation.messages.append(matchMessage)
                    }
                    
                    let systemMessage = Message(id: UUID().uuidString, role: .system, content: "John has made their selection", createdAt: Date())
                    conversation.messages.append(systemMessage)
                    
                }
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
