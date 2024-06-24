//
//  DetailViewModel.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import SwiftUI

class ChatViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var showBottomSheet: Bool = false
    @Published var exitGameAlert: Bool = false
    @Published var allowInput: Bool = true //allow user to choose prompt when follow-up messages are finished
    
     var conversationExposed: Conversation {
        gameMode ? conversationGame : conversationReg
    }
    
    //MARK: - game mode control
    @Published var conversationGame: Conversation = initialGameConversation
    @Published var conversationReg: Conversation = initialRegConversation
    
    
    @Published var gameMode: Bool = false
    
    @Published var currentLevel: String = "pre-start"
    {
        didSet {
            if currentLevel == "use the key to open the front door" {
                gameEnds()
            }
        }
    }
    
    func exitGame() {
        gameMode = false
        conversationGame = initialGameConversation
        sendRegMessage("You exited the game", .system)
        currentLevel = "pre-start"
    }
    
    private func gameEnds() {
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5){
            self.currentLevel = "pre-start"
            self.conversationGame = initialGameConversation
            self.sendRegMessage("You finished the game", .system)
            self.gameMode = false
        }
    }
    
    //MARK: - ---
    
    var fillColor: Color {
        return Color(uiColor: UIColor.systemBackground)
    }

    var strokeColor: Color {
        return Color(uiColor: UIColor.systemGray5)
    }

    func handleOptionSelection(_ option: String) {
            sendGameMessage(option, .userPrompt)
    }

    func tapSendMessage() {
        let message = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.isEmpty {
            return
        }
        
        if gameMode{
            let messageRole: MessageRole = levels.keys.contains(message.lowercased()) ? .userPrompt : .user
            //TODO: This should examine current the options, not all keys
            sendGameMessage(message, messageRole)
            inputText = ""
        } else {
            sendRegMessage(message, .user)
            inputText = ""

        }
    }

    func scrollToLastMessage(with scrollViewProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let lastMessage = self.conversationExposed.messages.last {
                withAnimation {
                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
    
    func sendRegMessage(_ message: String, _ role: MessageRole) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        conversationReg.messages.append(newMessage)//append immediately
        let matchMessage = Message(id: UUID().uuidString, role: .match, content: "followUp", createdAt: Date())
        
        let randomDelay = Double.random(in: 0.7...1.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            self.conversationReg.messages.append(matchMessage)
        }

    }
    
    func sendGameMessage(_ message: String, _ role: MessageRole) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        var cumulativeDelay: Double = 0
        
        if role == .user || role == .userPrompt {
            //immediately append user message
            conversationGame.messages.append(newMessage)//append immediately
        } else {
            appendWithCumulativeRandomDelay(newMessage)
        }
        
        // Follow up to the initial message
        if role == .userPrompt {
            if let level = levels[currentLevel], message == level.correctOption { // User selected correct prompt, level up
                currentLevel = level.correctOption // Update level
                allowInput = false //don't allow input until follow-up messages finish
                if let newLevel = levels[currentLevel] {
                    
                    // Add Host's description message
                    let aiMessage = Message(id: UUID().uuidString, role: .host, content: newLevel.description, createdAt: Date())
                    appendWithCumulativeRandomDelay(aiMessage)
                    
                    // Add Match's follow-up messages
                    for followUp in newLevel.matchMessages {
                        let matchMessage = Message(id: UUID().uuidString, role: .match, content: followUp, createdAt: Date())
                        appendWithCumulativeRandomDelay(matchMessage)
                    }
                    
                    let systemMessage = Message(id: UUID().uuidString, role: .system, content: "John has made their selection", createdAt: Date())
                    appendWithCumulativeRandomDelay(systemMessage)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay){
                        self.allowInput = true
                    }
                }
            } else if levels[currentLevel] != nil { //User selected wrong prompt
                allowInput = false //don't allow input until follow-up messages finish

                let aiMessage = Message(id: UUID().uuidString, role: .host, content: "Oops.. you two selected different option. Please discuss and come to an agreement to move on.", createdAt: Date())
                let matchMessage = Message(id: UUID().uuidString, role: .match, content: "lol I'm not changing my option tho.", createdAt: Date())

                appendWithCumulativeRandomDelay(aiMessage)
                appendWithCumulativeRandomDelay(matchMessage)
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay){
                    self.allowInput = true
                }
                
            } else {
                let errorMessage = Message(id: UUID().uuidString, role: .host, content: "I didn't understand that. Please try again.", createdAt: Date())
                appendWithCumulativeRandomDelay(errorMessage)
            }
        } else if role == .user { // user is chatting with the match
            let matchResponse = "Thanks for your input. Let's see what happens next."
            let matchMessage = Message(id: UUID().uuidString, role: .match, content: matchResponse, createdAt: Date())
            appendWithCumulativeRandomDelay(matchMessage)
        }
        
        func appendWithCumulativeRandomDelay(_ content: Message) {
            let randomIncrement = Double.random(in: 0.7...1.1)
            cumulativeDelay += randomIncrement
            DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay) {
                self.conversationGame.messages.append(content)
            }
        }
    }


    
}
