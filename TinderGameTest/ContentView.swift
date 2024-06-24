//
//  ContentView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    @State private var conversation = initialConversation
    @State private var error: Error?
    
    var body: some View {
        DetailView(
            conversation: conversation,
            error: error,
            sendMessage: sendMessage
        )
    }
    
    private func sendMessage(_ message: String, role: MessageRole) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        conversation.messages.append(newMessage)
        
        if role == .userPrompt {
            if let level = levels[currentLevel]
             {
                let aiMessage = Message(id: UUID().uuidString, role: .host, content: level.description, createdAt: Date())
                conversation.messages.append(aiMessage)
                currentLevel = level.correctOption
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
