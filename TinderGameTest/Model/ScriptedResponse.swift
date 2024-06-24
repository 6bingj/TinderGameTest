//
//  ScriptedResponse.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import Foundation

var initialConversation = Conversation(
    id: "1",
    messages: [
        Message(id: "1", role: .host, content:levels["pre-start"]?.description ?? "Start point", createdAt: Date())
    ]
)

struct Level {
    let description: String
    let options: [String]
    let correctOption: String
    let matchMessages: [String]
}

let levels: [String: Level] = [
    "pre-start": Level(
        description: """
                Welcome to the Haunted House Escape! You need to work together to find clues and solve puzzles to escape this ever-changing mansion. You have 20 minutes. Good luck! Tap "Start" to begin your exploration. You could chat with your match at anytime to discuss your options.
                """,
        options: ["start"],
        correctOption: "start",
        matchMessages: [
            "OMG, are you ready to start? Let's do this! 😁",
            "So excited! Tap 'Start' and let's get spooky! 👻"
        ]
    ),
    "start": Level(
        description: "You find yourselves in the mansion's dimly lit foyer. The air is cold, and the sound of distant whispers sends shivers down your spine. The front door is locked. There are two doors, one to the left and one to the right.",
        options: ["open the left door", "open the right door"],
        correctOption: "open the left door",
        matchMessages: [
            "Ugh, so creepy... Which door should we choose? 🤔",
            "The whispers are giving me chills. Left door maybe?",
            "Let's try the left door first. What do you think? 😅"
        ]
    ),
    "open the left door": Level(
        description: "The left door creaks open, revealing a dusty library. Shelves of old books line the walls, and a large portrait of a stern-looking man hangs above a fireplace. A strange symbol is carved into the mantelpiece.",
        options: ["examine the portrait", "back to the right door"],
        correctOption: "examine the portrait",
        matchMessages: [
            "A library! Bet there's something hidden here. 📚",
            "That portrait looks sus. Should we check it out?",
            "OMG, that symbol looks important. Let's peep the portrait first."
        ]
    ),
    "examine the portrait": Level(
        description: "As you examine the portrait, you notice it swings away to reveal a hidden safe. The safe requires a 4-digit code.",
        options: ["try to open the safe", "search the room for clues"],
        correctOption: "search the room for clues",
        matchMessages: [
            "A hidden safe? This is like a movie! 🎬",
            "The code has to be here somewhere. Let's find it!",
            "Time to search for clues! We got this! 🔍"
        ]
    ),
    "search the room for clues": Level(
        description: "You search the room and find an old journal. Inside, you discover a torn page with the numbers '1847' written in shaky handwriting.",
        options: ["enter the code 1847", "keep searching the room"],
        correctOption: "enter the code 1847",
        matchMessages: [
            "This journal looks ancient. What's inside? 📖",
            "'1847' - that's gotta be the code!",
            "Let's try '1847' on the safe. Fingers crossed! 🤞"
        ]
    ),
    "enter the code 1847": Level(
        description: "The safe clicks open, revealing an old key and a note that reads, 'The key to your escape lies in the heart of the mansion.'",
        options: ["use the key to open the front door", "look for another clue"],
        correctOption: "use the key to open the front door",
        matchMessages: [
            "We got the key! Yasss! 🔑",
            "The note says 'heart of the mansion'. Should we try the front door?",
            "Let's use the key on the front door and see if it works! 🗝️"
        ]
    )
]
