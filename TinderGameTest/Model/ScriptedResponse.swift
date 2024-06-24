//
//  ScriptedResponse.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import Foundation

struct ScriptedResponse {
    let userMessage: String
    let aiResponse: String
}

let script: [ScriptedResponse] = [
    ScriptedResponse(userMessage: "start", aiResponse: "Welcome to the Haunted House Escape! You and your match need to work together to find clues and solve puzzles to escape this mansion. You have 30 minutes. Good luck! You find yourselves in the mansion's dimly lit foyer. The air is cold, and the sound of distant whispers sends shivers down your spine. The front door is locked. There are two doors, one to the left and one to the right."),
    ScriptedResponse(userMessage: "left door", aiResponse: "The left door creaks open, revealing a dusty library. Shelves of old books line the walls, and a large portrait of a stern-looking man hangs above a fireplace. A strange symbol is carved into the mantelpiece."),
    ScriptedResponse(userMessage: "portrait", aiResponse: "As you examine the portrait, you notice it swings away to reveal a hidden safe. The safe requires a 4-digit code."),
    // Add more scripted responses as needed
]

var initialConversation = Conversation(
    id: "1",
    messages: [
        Message(id: "1", role: .host, content: script[0].aiResponse, createdAt: Date())
    ]
)
