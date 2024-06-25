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
    
    @Published var currentLevel: String = "Pre-start"
    {
        didSet {
            if currentLevel == "Use the key to open the front door" {
                gameEnds()
            }
        }
    }
    
    func exitGame() {
        gameMode = false
        conversationGame = initialGameConversation
        gameEndingMessages(action: .exit)
        currentLevel = "Pre-start"
    }
    
    private func gameEnds() {
        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5){
            self.currentLevel = "Pre-start"
            self.conversationGame = initialGameConversation
            self.gameEndingMessages(action: .end)
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
    
    //MARK: - Send Messages
    func sendRegMessage(_ message: String, _ role: MessageRole) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        conversationReg.messages.append(newMessage)//append immediately
        
        let matchResponse = cannedResponses.randomElement() ?? "Haha, that's interesting!"
        let matchMessage = Message(id: UUID().uuidString, role: .match, content: matchResponse, createdAt: Date())
        let letsGameMessage = Message(id: UUID().uuidString, role: .match, content: "But let's play the game now please?", createdAt: Date())

        let randomDelay = Double.random(in: 0.7...1.1)
        let randomDelay2 = Double.random(in: 0.7...1.1)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            self.conversationReg.messages.append(matchMessage)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay + randomDelay2) {
            self.conversationReg.messages.append(letsGameMessage)
        }
    }
    
    enum GameEndingAction {
        case end
        case exit
    }

    func gameEndingMessages(action: GameEndingAction) {
        let (actionMessage, followUpMessage): (String, String) = {
            switch action {
            case .end:
                return ("Congratulations! You've successfully escaped the haunted mansion.", "That was so much fun! I'm glad we played it together. 😊")
            case .exit:
                return ("You've exited the Haunted House Escape game.", "Aww, looks like we had to leave the game early. But it was still fun! 😅")
            }
        }()
        
        let newMessage = Message(id: UUID().uuidString, role: .system, content: actionMessage, createdAt: Date())
        conversationReg.messages.append(newMessage)
        
        let matchMessage = Message(id: UUID().uuidString, role: .match, content: followUpMessage, createdAt: Date())
        
        let randomDelay = Double.random(in: 0.7...1.1)
        DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay) {
            self.conversationReg.messages.append(matchMessage)
        }
    }

    
    func sendGameMessage(_ message: String, _ role: MessageRole) {
        let newMessage = Message(id: UUID().uuidString, role: role, content: message, createdAt: Date())
        var cumulativeDelay: Double = 0
        
        // Follow up to the initial message
        if role == .userPrompt {
            if let level = levels[currentLevel], message == level.correctOption { // User selected correct prompt, level up
                conversationGame.messages.append(newMessage)//append prompt immediately
                
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
                    
                    let systemMessage = Message(id: UUID().uuidString, role: .system, content: "Ryan has made their selection", createdAt: Date())
                    
                    if currentLevel != "Use the key to open the front door" {
                        appendWithCumulativeRandomDelay(systemMessage)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay){
                        self.allowInput = true
                    }
                }
            } else if levels[currentLevel] != nil { //User selected wrong prompt
                //Don't append message
                allowInput = false //don't allow input until follow-up messages finish

                let aiMessage = Message(id: UUID().uuidString, role: .host, content: "Oops.. you two selected different options. Discuss and select the same option to move on.", createdAt: Date())
                let matchMessage = Message(id: UUID().uuidString, role: .match, content: "lol I'm not changing my option tho.", createdAt: Date())

                conversationGame.messages.append(aiMessage) //immediate feedback
                appendWithCumulativeRandomDelay(matchMessage)
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + cumulativeDelay){
                    self.allowInput = true
                }
                
            } else {
                let errorMessage = Message(id: UUID().uuidString, role: .host, content: "I didn't understand that. Please try again.", createdAt: Date())
                appendWithCumulativeRandomDelay(errorMessage)
            }
        } else if role == .user { // user is chatting with the match
            conversationGame.messages.append(newMessage)//append message immediately
            let matchResponse = cannedResponses.randomElement() ?? "Haha, that's interesting!"
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
    
    func gameChatInitFollowUp() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            let matchMessage = Message(id: UUID().uuidString, role: .match, content: "OOOOKay let's do this", createdAt: Date())
            let systemMessage = Message(id: UUID().uuidString, role: .system, content: "Ryan has made their selection", createdAt: Date())
            self.conversationGame.messages.append(matchMessage)
            self.conversationGame.messages.append(systemMessage)

        }
    }


    
}
