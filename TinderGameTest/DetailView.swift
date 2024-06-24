//
//  DetailView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

class DetailViewModel: ObservableObject {
    @Published var inputText: String = ""
    @Published var conversation: Conversation = initialConversation
    @Published var currentLevel: String = "pre-start"
    
    var fillColor: Color {
        return Color(uiColor: UIColor.systemBackground)
    }

    var strokeColor: Color {
        return Color(uiColor: UIColor.systemGray5)
    }

    func handleOptionSelection(_ option: String) {
        if let level = levels[currentLevel], option == level.correctOption {
            sendMessage(option, .userPrompt)
        } else {
            
            sendMessage("Oops.. you two selected different option. Please discuss and come to an agreement to move on.", .host)
            
            sendMessage("lol I'm not changing my option tho.", .match)
            
        }
    }

    func tapSendMessage() {
        let message = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.isEmpty {
            return
        }

        let messageRole: MessageRole = levels.keys.contains(message.lowercased()) ? .userPrompt : .user
        //TODO: This should examine current the options, not all keys
        
        sendMessage(message, messageRole)
        inputText = ""
    }

    func scrollToLastMessage(with scrollViewProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let lastMessage = self.conversation.messages.last {
                withAnimation {
                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }

    func sendMessage(_ message: String, _ role: MessageRole) {
        MessageHandling.sendMessage(message, role: role, conversation: &conversation, currentLevel: &currentLevel)
    }
}



struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(viewModel.conversation.messages) { message in
                                ChatBubble(message: message)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .animation(.default, value: viewModel.conversation.messages)
                    .onChange(of: viewModel.conversation.messages) {
                        viewModel.scrollToLastMessage(with: scrollViewProxy)
                    }
                    
                    optionButtons()
                    
                    inputBar()
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
    
    @ViewBuilder private func inputBar() -> some View {
        HStack {
            TextEditor(
                text: $viewModel.inputText
            )
            .padding(.vertical, -8)
            .padding(.horizontal, -4)
            .frame(minHeight: 22, maxHeight: 300)
            .foregroundColor(.primary)
            .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
            .background(
                RoundedRectangle(
                    cornerRadius: 16,
                    style: .continuous
                )
                .fill(viewModel.fillColor)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                    .stroke(
                        viewModel.strokeColor,
                        lineWidth: 1
                    )
                )
            )
            .fixedSize(horizontal: false, vertical: true)
            .padding(.leading)

            Button(action: {
                withAnimation {
                    viewModel.tapSendMessage()
                }
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.trailing)
            }
            .disabled(viewModel.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.bottom)
    }
}




struct DetailView_Previews: PreviewProvider {
    @State static var previewConversation = Conversation(
        id: "1",
        messages: [
            Message(id: "1", role: .user, content: "Hello", createdAt: Date(timeIntervalSinceReferenceDate: 0)),
            Message(id: "2", role: .user, content: "I need help.", createdAt: Date(timeIntervalSinceReferenceDate: 100)),
            Message(id: "3", role: .match, content: "Aw what's the matter?", createdAt: Date(timeIntervalSinceReferenceDate: 200)),
            Message(id: "4", role: .host, content: "I didn't understand that. Please try again.", createdAt: Date(timeIntervalSinceReferenceDate: 300)),
            Message(id: "5", role: .userPrompt, content: "Open the right door", createdAt: Date(timeIntervalSinceReferenceDate: 400))
        ]
    )

    static var previews: some View {
        DetailView()
    }
}
