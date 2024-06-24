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
                VStack {
                    if viewModel.gameMode {
                        gameChatView
                            .transition(.asymmetric(
                                insertion: .move(edge: .bottom).combined(with: .opacity),
                                removal: .move(edge: .bottom).combined(with: .opacity)
                            ))
                    } else {
                        regChatView
                            .transition(.asymmetric(
                                insertion: .move(edge: .top).combined(with: .opacity),
                                removal: .move(edge: .top).combined(with: .opacity)
                            ))
                    }
                    inputBar($viewModel.inputText, fillColor: viewModel.fillColor, strokeColor: viewModel.strokeColor, tapSendMessage: viewModel.tapSendMessage)
                }
            
        }
    }
    
    @ViewBuilder private var gameChatView: some View {
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
        }
        optionButtons()
        
        Button {
            withAnimation {
                viewModel.gameMode.toggle()
            }
        } label: {
            Text("toggle")
        }
    }
    
    @ViewBuilder private var regChatView: some View {
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
        }
        
        Button {
            withAnimation {
                viewModel.gameMode.toggle()
            }
        } label: {
            Text("toggle")
                .foregroundStyle(.cyan)
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

    static var previews: some View {
        ChatView()
    }
}
