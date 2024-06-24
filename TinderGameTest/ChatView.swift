//
//  DetailView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.conversationExposed.messages) { message in
                                ChatBubble(message: message)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .animation(.default, value: viewModel.conversationExposed.messages)
                    .onChange(of: viewModel.conversationExposed.messages) {
                        viewModel.scrollToLastMessage(with: scrollViewProxy)
                    }
                    
                    optionButtons()
                    
                    Button {
                        viewModel.gameMode.toggle()
                    } label: {
                        Text("toggle")
                    }

                    
                    inputBar($viewModel.inputText, fillColor: viewModel.fillColor, strokeColor: viewModel.strokeColor, tapSendMessage: viewModel.tapSendMessage)
                }
            }
        }
    }

    @ViewBuilder private func optionButtons() -> some View {
        if let level = levels[viewModel.currentLevel] {
            ForEach(level.options, id: \.self) { option in
                Button(action: {
                    viewModel.handleOptionSelection(option)
                }) {
                    Text(option)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color(red: 241 / 255, green: 116 / 255, blue: 189 / 255), lineWidth: 2)
                        )
                    if option == level.correctOption {
                        // Additional UI elements for correct option
                    }
                }
            }
        }
    }
    
}




struct GameView_Previews: PreviewProvider {
//    @State static var previewConversation = Conversation(
//        id: "1",
//        messages: [
//            Message(id: "1", role: .user, content: "Hello", createdAt: Date(timeIntervalSinceReferenceDate: 0)),
//            Message(id: "2", role: .user, content: "I need help.", createdAt: Date(timeIntervalSinceReferenceDate: 100)),
//            Message(id: "3", role: .match, content: "Aw what's the matter?", createdAt: Date(timeIntervalSinceReferenceDate: 200)),
//            Message(id: "4", role: .host, content: "I didn't understand that. Please try again.", createdAt: Date(timeIntervalSinceReferenceDate: 300)),
//            Message(id: "5", role: .userPrompt, content: "Open the right door", createdAt: Date(timeIntervalSinceReferenceDate: 400))
//        ]
//    )

    static var previews: some View {
        ChatView()
    }
}
