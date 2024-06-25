//
//  GameChatView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import SwiftUI

struct GameChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack{
            ScrollViewReader { scrollViewProxy in
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
                .onAppear {
                    viewModel.gameChatInitFollowUp()
                }
            }
            
            optionButtons
            
        }
    }
    
    @ViewBuilder var optionButtons: some View {
        if let level = levels[viewModel.currentLevel], viewModel.allowInput {
            ForEach(level.options, id: \.self) { option in
                Button(action: {
                    viewModel.handleOptionSelection(option)
                }) {
                    HStack {
                        Spacer()
                        Text(option)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
//                    .background(Color.white)
                    .background(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color(.systemGray5))
                            .stroke(Color(red: 241 / 255, green: 116 / 255, blue: 189 / 255), lineWidth: 2)
                )
                    .padding(.horizontal, 30)

                    if option == level.correctOption {
                        // Additional UI elements for correct option
                    }
                }
                .tint(Color(red: 241 / 255, green: 116 / 255, blue: 189 / 255))
                .disabled(!viewModel.allowInput)
            }
        }
    }
    
}

#Preview {
    GameChatView(viewModel: {
        let viewModel = ChatViewModel()
        viewModel.gameMode = true
        return viewModel
    }())
}
