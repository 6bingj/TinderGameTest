//
//  DetailViewModel.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var conversation: Conversation = initialConversation
    @Published var currentLevel: String = "pre-start"
    
    var fillColor: Color {
        return Color(uiColor: UIColor.systemBackground)
    }

    var strokeColor: Color {
        return Color(uiColor: UIColor.systemGray5)
    }

    func handleOptionSelection(_ option: String) {
        if let level = levels[currentLevel], option == level.correctOption {
            sendMessage(option, .userPrompt)
        } else {
            
            sendMessage("Oops.. you two selected different option. Please discuss and come to an agreement to move on.", .host)
            
            sendMessage("lol I'm not changing my option tho.", .match)
            
        }
    }

    func tapSendMessage() {
        let message = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.isEmpty {
            return
        }

        let messageRole: MessageRole = levels.keys.contains(message.lowercased()) ? .userPrompt : .user
        //TODO: This should examine current the options, not all keys
        
        sendMessage(message, messageRole)
        inputText = ""
    }

    func scrollToLastMessage(with scrollViewProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let lastMessage = self.conversation.messages.last {
                withAnimation {
                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
    
    
    func sendMessage(_ message: String, _ role: MessageRole) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        var cumulativeDelay: Double = 0
        
        if role == .user || role == .userPrompt {
            //immediately append user message
            conversation.messages.append(newMessage)//append immediately
        } else {
            appendWithCumulativeRandomDelay(newMessage, cumulativeDelay: &cumulativeDelay)
        }
        
        // Follow up to the initial message
        if role == .userPrompt {
            if let level = levels[currentLevel] { // User selected correct prompt, level up
                currentLevel = level.correctOption // Update level
                if let newLevel = levels[currentLevel] {
                    
                    // Add Host's description message
                    let aiMessage = Message(id: UUID().uuidString, role: .host, content: newLevel.description, createdAt: Date())
                    appendWithCumulativeRandomDelay(aiMessage, cumulativeDelay: &cumulativeDelay)
                    
                    // Add Match's follow-up messages
                    for followUp in newLevel.matchMessages {
                        let matchMessage = Message(id: UUID().uuidString, role: .match, content: followUp, createdAt: Date())
                        appendWithCumulativeRandomDelay(matchMessage, cumulativeDelay: &cumulativeDelay)
                    }
                    
                    let systemMessage = Message(id: UUID().uuidString, role: .system, content: "John has made their selection", createdAt: Date())
                    appendWithCumulativeRandomDelay(systemMessage, cumulativeDelay: &cumulativeDelay)
                    
                }
            } else {
                let errorMessage = Message(id: UUID().uuidString, role: .host, content: "I didn't understand that. Please try again.", createdAt: Date())
                appendWithCumulativeRandomDelay(errorMessage, cumulativeDelay: &cumulativeDelay)
            }
        } else if role == .user { // user is chatting with the match
            let matchResponse = "Thanks for your input. Let's see what happens next."
            let matchMessage = Message(id: UUID().uuidString, role: .match, content: matchResponse, createdAt: Date())
            appendWithCumulativeRandomDelay(matchMessage, cumulativeDelay: &cumulativeDelay)
        }
    }

    func appendWithCumulativeRandomDelay(_ content: Message, cumulativeDelay: inout Double) {
        let randomIncrement = Double.random(in: 0.7...1.1)
        cumulativeDelay += randomIncrement
        DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
            self.conversation.messages.append(content)
        }
    }
    
}
