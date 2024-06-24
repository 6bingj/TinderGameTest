//
//  Conversation.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import Foundation

struct Conversation {
    init(id: String, messages: [Message] = []) {
        self.id = id
        self.messages = messages
    }
    
    typealias ID = String
    
    let id: String
    var messages: [Message]
}

extension Conversation: Equatable, Identifiable {}


struct Message {
    var id: String
//    var role: ChatQuery.ChatCompletionMessageParam.Role
    var role: MessageRole
    var content: String
    var createdAt: Date
}

extension Message: Equatable, Codable, Hashable, Identifiable {}


enum MessageRole: String, Codable, Equatable, CaseIterable {
    case user
    case host
    case match
    case userPrompt
    case system
}
