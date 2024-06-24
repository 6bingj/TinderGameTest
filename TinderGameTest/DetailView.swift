//
//  DetailView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

struct DetailView: View {
    @State var inputText: String = ""

    let conversation: Conversation
    let error: Error?
    let sendMessage: (String, MessageRole) -> Void

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
                    
                    optionButtons()

                    inputBar()
                }
            }
        }
    }

    @ViewBuilder private func optionButtons() -> some View {
        if let level = levels[currentLevel] {
            ForEach(level.options, id: \.self) { option in
                Button(action: {
                    handleOptionSelection(option)
                }) {
                    Text(option)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.white) // This should match the background color of your overall view to make it transparent
                        .overlay(
                            RoundedRectangle(cornerRadius: 40)
                                .stroke(Color(red: 241 / 255, green: 116 / 255, blue: 189 / 255), lineWidth: 2) // Border color and width
                        )
                    if option == level.correctOption {
//                        Text("check")
                        //TODO: add match profile picture to show they selected this
                    }
                }
            }
        }
    }
    
    private func handleOptionSelection(_ option: String) {
        if let level = levels[currentLevel], option == level.correctOption {
            sendMessage(option, .userPrompt)
        } else {
            sendMessage("Hmmm yeah but I think the other option is better. Please?", .match)
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

        let messageRole: MessageRole = levels.keys.contains(message.lowercased()) ? .userPrompt : .user
        
        sendMessage(message, messageRole)
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
                
                
            case .userPrompt:
                Spacer(minLength: 24)
                Text(message.content)
                    .foregroundColor(.black)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
//                    .background(Color.clear) // This should match the background color of your overall view to make it transparent
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 40)
//                            .stroke(Color(red: 241 / 255, green: 116 / 255, blue: 189 / 255), lineWidth: 2) // Border color and width
//                    )
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
                Message(id: "1", role: .user, content: "Hello?", createdAt: Date(timeIntervalSinceReferenceDate: 0)),
                Message(id: "2", role: .user, content: "I need help.", createdAt: Date(timeIntervalSinceReferenceDate: 100)),
                Message(id: "3", role: .match, content: "Aw what's the matter?", createdAt: Date(timeIntervalSinceReferenceDate: 200)),
                Message(id: "4", role: .host, content:
                          """
                          Magna nulla tempor in. Proident laboris et laborum. Occaecat aute adipisicing duis excepteur non non elit Lorem voluptate irure. Do Lorem nostrud aute aute aliquip enim. Ad exercitation ut enim adipisicing irure amet aute laboris magna culpa labore aliqua. Fugiat et aute cupidatat eu ea qui sunt labore. Lorem culpa elit cillum labore duis ea ad ex duis aliqua ex veniam.
                          """, createdAt: Date(timeIntervalSinceReferenceDate: 200)),
                Message(id: "5", role: .userPrompt, content: "Open the right door", createdAt: Date(timeIntervalSinceReferenceDate: 200))

            ]
        ),
        error: nil,
        sendMessage: { _,_  in }
    )
}
