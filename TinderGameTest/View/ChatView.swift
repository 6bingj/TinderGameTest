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
                    inputBar($viewModel.inputText, fillColor: viewModel.fillColor, strokeColor: viewModel.strokeColor, tapSendMessage: viewModel.tapSendMessage)
                }
                
                if viewModel.showBottomSheet {
                    bottomSheet
                        .transition(.asymmetric(
                            insertion: .move(edge: .bottom).combined(with: .opacity),
                            removal: .move(edge: .bottom).combined(with: .opacity)
                        ))
                }
            }
            
        }
    }
    
    @ViewBuilder private var gameButton: some View {
        if viewModel.gameMode{
            Button {
                viewModel.exitGameAlert.toggle()
            } label: {
                Image(systemName: "door.right.hand.open")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
            }
            .padding()
            
        } else {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.showBottomSheet.toggle()
                }
            } label: {
                Image(systemName: "gamecontroller")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
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
    
    @ViewBuilder private var bottomSheet: some View {
        ScrollView {
            Text("Break the Ice with the AI Game Master")
            
            Button {
                viewModel.showBottomSheet.toggle()
                withAnimation{
                    viewModel.gameMode.toggle()
                }
                
            } label: {
                VStack(alignment: .leading) {
                    Text("Haunted House Escape")
                        .font(.title2)
                    Text("A special storyline generated just for you. Ask any questions to the AI host, and escape together!")
                        .font(.subheadline)
                        .multilineTextAlignment(.leading)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25.0)
                        .fill(.gray)
                )
                .padding()
            }
            .tint(.white)
            
        }
        .background()
        .frame(maxHeight: 300)
    }
    
}




struct GameView_Previews: PreviewProvider {
    
    static var previews: some View {
        ChatView()
    }
}
