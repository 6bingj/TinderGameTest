//
//  ContentView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "globe")
//                .imageScale(.large)
//                .foregroundStyle(.tint)
//            Text("Hello, world!")
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}

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
    
    private func sendMessage(_ message: String) {
        let newMessage = Message(id: UUID().uuidString, role: .user, content: message, createdAt: Date())
        conversation.messages.append(newMessage)
        
        if let response = script.first(where: { $0.userMessage.lowercased() == message.lowercased() }) {
            let aiMessage = Message(id: UUID().uuidString, role: .host, content: response.aiResponse, createdAt: Date())
            conversation.messages.append(aiMessage)
        } else {
            let errorMessage = Message(id: UUID().uuidString, role: .host, content: "I didn't understand that. Please try again.", createdAt: Date())
            conversation.messages.append(errorMessage)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
