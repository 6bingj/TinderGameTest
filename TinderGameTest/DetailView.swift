//
//  DetailView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

struct DetailView: View {
    @State var inputText: String = ""
//    @FocusState private var isFocused: Bool


    let conversation: Conversation
    let error: Error?
    let sendMessage: (String) -> Void

    private var fillColor: Color {
        return Color(uiColor: UIColor.systemBackground)
    }

    private var strokeColor: Color {
        return Color(uiColor: UIColor.systemGray5)
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollViewProxy in
                VStack {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(conversation.messages) { message in
                                ChatBubble(message: message)
                            }
                            .padding(.horizontal)
                        }
                    }
                    .animation(.default, value: conversation.messages)
                    .onChange(of: conversation.messages) {
                        scrollToLastMessage(with: scrollViewProxy)
                    }
                    
//                    if let error = error {
//                        errorMessage(error: error)
//                    }

                    inputBar()
                }
            }
        }
    }

    @ViewBuilder private func inputBar() -> some View {
        HStack {
            TextEditor(
                text: $inputText
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
                .fill(fillColor)
                .overlay(
                    RoundedRectangle(
                        cornerRadius: 16,
                        style: .continuous
                    )
                    .stroke(
                        strokeColor,
                        lineWidth: 1
                    )
                )
            )
            .fixedSize(horizontal: false, vertical: true)
//            .onSubmit {
//                withAnimation {
//                    tapSendMessage()
//                }
//            }
            .padding(.leading)

            Button(action: {
                withAnimation {
                    tapSendMessage()
                }
            }) {
                Image(systemName: "arrow.up.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.trailing)
            }
            .disabled(inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding(.bottom)
    }
    
    private func tapSendMessage() {
        let message = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if message.isEmpty {
            return
        }
        
        sendMessage(message)
        inputText = ""
        
    }
    
    
    private func scrollToLastMessage(with scrollViewProxy: ScrollViewProxy) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let lastMessage = conversation.messages.last {
                withAnimation {
                    scrollViewProxy.scrollTo(lastMessage.id, anchor: .bottom)
                }
            }
        }
    }
}


struct ThreeRoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ChatBubble: View {
    let message: Message

    private var matchBackgroundColor: Color {
        return Color(uiColor: UIColor.systemGray5)
    }
    
    private var assistantBackgroundColor: Color {
        return Color(red: 241 / 255, green: 116 / 255, blue: 189 / 255)
    }

    private var userForegroundColor: Color {
        return Color(uiColor: .white)
    }

    private var userBackgroundColor: Color {
        return Color(uiColor: .systemBlue)
    }

    var body: some View {
        HStack(alignment:.bottom) {
            switch message.role {
            case .host:
                Circle()
                    .frame(width: 40)
                Text(message.content)
                    .foregroundColor(userForegroundColor)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(assistantBackgroundColor)
                    .clipShape(
                        ThreeRoundedCornersShape(corners: [.topLeft, .topRight, .bottomRight], radius: 16)

                    )
                Spacer(minLength: 24)
            case .user:
                Spacer(minLength: 24)
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .foregroundColor(userForegroundColor)
                    .background(userBackgroundColor)
                    .clipShape(
                        ThreeRoundedCornersShape(corners: [.topLeft, .topRight, .bottomLeft], radius: 16)
                    )
            case .match:
                Circle()
                    .frame(width: 40)
                    .foregroundStyle(.yellow)
              Text(message.content)
                  .padding(.horizontal, 16)
                  .padding(.vertical, 12)
                  .background(matchBackgroundColor)
                  .clipShape(
                    ThreeRoundedCornersShape(corners: [.topLeft, .topRight, .bottomRight], radius: 16)
                  )
              Spacer(minLength: 24)
            }
        }
    }
}

#Preview {
    DetailView(
        conversation: Conversation(
            id: "1",
            messages: [
                Message(id: "1", role: .user, content: "Hello, how can I help you today?", createdAt: Date(timeIntervalSinceReferenceDate: 0)),
                Message(id: "2", role: .user, content: "I need help with my subscription.", createdAt: Date(timeIntervalSinceReferenceDate: 100)),
                Message(id: "3", role: .match, content: "Sure, what seems to be the problem with your subscription?", createdAt: Date(timeIntervalSinceReferenceDate: 200)),
                Message(id: "4", role: .host, content:
                          """
                          get_current_weather({
                            "location": "Glasgow, Scotland",
                            "format": "celsius"
                          })
                          """, createdAt: Date(timeIntervalSinceReferenceDate: 200))
            ]
        ),
        error: nil,
        sendMessage: { _ in }
    )
}
