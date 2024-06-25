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
        
        VStack {
            
            ChatToolbar()
                .padding(.horizontal)
                .padding(.bottom, 4)
                .background()
                .shadow(color: .secondary.opacity(0.3) ,radius: 10, y: 1)
            
            
            if viewModel.gameMode {
                GameChatView(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
                    .alert("Exit the game?", isPresented: $viewModel.exitGameAlert) {
                        Button("Exit") {
                            withAnimation {
                                viewModel.exitGame()
                            }
                        }
                        Button("Cancel", role: .cancel, action: {})
                    }
            } else {
                
                
                regChatView
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .preferredColorScheme(.light)
            }
            
            HStack(alignment:.center) {
                gameButton
                InputBar(text: $viewModel.inputText, tapSendMessage: viewModel.tapSendMessage)
            }
            
            if viewModel.showBottomSheet {
                ChatViewBottomSheet(viewModel: viewModel)
                    .transition(.asymmetric(
                        insertion: .move(edge: .bottom).combined(with: .opacity),
                        removal: .move(edge: .bottom).combined(with: .opacity)
                    ))
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        
        
    }
    
    @ViewBuilder private var gameButton: some View {
        if viewModel.gameMode{
            Button {
                viewModel.exitGameAlert.toggle()
            } label: {
                Image(systemName: "door.right.hand.open")
                    .font(.title2)
            }
            .tint(.primary)
            .padding()
            
        } else {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.showBottomSheet.toggle()
                }
            } label: {
                Image(systemName: viewModel.showBottomSheet ? "xmark" : "gamecontroller")
                    .font(.title2)
            }
            .padding()
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
        
    }
    
}




#Preview {
    ChatView()
}
