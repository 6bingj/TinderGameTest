//
//  ScriptedResponse.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import Foundation

var initialGameConversation = Conversation(
    id: "1",
    messages: [
        Message(id: "1", role: .host, content:levels["Pre-start"]?.description ?? "Start point", createdAt: Date())
    ]
)

var initialRegConversation = Conversation(
    id: "2",
    messages: [
        Message(id: "1", role: .user, content:"Hey, how's it going?", createdAt: Date()),
        Message(id: "2", role: .match, content:"Hey hey! Pretty good, thanks. Your profile said you are an adventurer... prove to me?😛", createdAt: Date()),
        Message(id: "3", role: .user, content:"lol I will let you judge it. ", createdAt: Date()), //Have you heard about the new mini games on Tinder?
        Message(id: "4", role: .match, content:"Yeah! Show me what you got 😁 The game button is on the lower left.", createdAt: Date()),
    ]
)

struct Level {
    let description: String
    let options: [String]
    let correctOption: String
    let matchMessages: [String]
}

let levels: [String: Level] = [
    "Pre-start": Level(
        description: """
                Welcome to the haunted house escape! I'm your AI game host 😁\n - You need to work together to find clues and solve puzzles to escape this ever-changing mansion.\n - You need select the same option to move forward in the game \n - Discuss or ask me any questions!
                """,
        options: ["Start"],
        correctOption: "Start",
        matchMessages: [
            "OMG, are you ready to start? Let's do this! 😁",
            "So excited! Tap 'Start' and let's get spooky! 👻"
        ]
    ),
    "Start": Level(
        description: "You find yourselves in the mansion's dimly lit foyer. The air is cold, and the sound of distant whispers sends shivers down your spine. The front door is locked. There are two doors, one to the left and one to the right.",
        options: ["Open the left door", "Open the right door"],
        correctOption: "Open the left door",
        matchMessages: [
            "Ugh, so creepy... Which door should we choose? 🤔",
            "Let's discuss which option to choose before we select",
        ]
    ),
    "Open the left door": Level(
        description: "The left door creaks open, revealing a dusty library. Shelves of old books line the walls, and a large portrait of a stern-looking man hangs above a fireplace. A strange symbol is carved into the mantelpiece.",
        options: ["Examine the portrait", "Back to the right door"],
        correctOption: "Examine the portrait",
        matchMessages: [
            "A library! Bet there's something hidden here. 📚",
            "That portrait looks sus. Should we check it out?",
            "OMG, that symbol looks important. Let's peep the portrait first."
        ]
    ),
    "Examine the portrait": Level(
        description: "As you examine the portrait, you notice it swings away to reveal a hidden safe. The safe requires a 4-digit code.",
        options: ["Try to open the safe", "Search the room for clues"],
        correctOption: "Search the room for clues",
        matchMessages: [
            "A hidden safe? This is like a movie! 🎬",
            "The code has to be here somewhere. Let's find it!",
            "Time to search for clues! We got this! 🔍"
        ]
    ),
    "Search the room for clues": Level(
        description: "You search the room and find an old journal. Inside, you discover a torn page with the numbers '1847' written in shaky handwriting.",
        options: ["Enter the code 1847", "Keep searching the room"],
        correctOption: "Enter the code 1847",
        matchMessages: [
            "This journal looks ancient. What's inside? 📖",
            "'1847' - that's gotta be the code!",
            "Let's try '1847' on the safe. Fingers crossed! 🤞"
        ]
    ),
    "Enter the code 1847": Level(
        description: "The safe clicks open, revealing an old key and a note that reads, 'The key to your escape lies in the heart of the mansion.'",
        options: ["Use the key to open the front door", "Look for another clue"],
        correctOption: "Use the key to open the front door",
        matchMessages: [
            "We got the key! Yasss! 🔑",
            "The note says 'heart of the mansion'. Should we try the front door?",
            "Let's use the key on the front door and see if it works! 🗝️"
        ]
    ),
    "Use the key to open the front door": Level(
        description: "Congratulations! You've successfully escaped the haunted mansion.",
        options: [],
        correctOption: "",
        matchMessages: []
    )
]

let cannedResponses = [
    "Haha, that's interesting! Tell me more! 😊",
    "I totally get that.",
    "Wow, that's so cool! How did you get into that?",
    "Haha, you're funny! 😄",
    "Really? I've always wanted to try that!",
    "No way! That's awesome! 👏",
    "I never thought of it that way. You're so insightful.",
    "That's amazing! You must have some great stories.",
    "I'd love to hear more about that!",
    "That's so unique! What's it like?",
    "Omg, same here! We have so much in common. 😍",
    "Haha, I can't believe it! That's awesome.",
    "You're really interesting. Tell me more!",
    "I love that! How did you start doing that?",
    "That's really impressive. You're so talented!",
    "No way, that's incredible! How did you manage that?"
]
