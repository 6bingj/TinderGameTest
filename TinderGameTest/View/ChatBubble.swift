//
//  ChatBubble.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

@ViewBuilder func inputBar(_ text: Binding<String>, fillColor: Color, strokeColor: Color, tapSendMessage: @escaping () -> Void) -> some View {
    HStack {
        TextEditor(
            text: text
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
        .disabled(text.wrappedValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    .padding(.bottom)
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
                VStack{
                    HStack{
                        Spacer(minLength: 30)
                        Rectangle()
                            .frame(height: 1)
                        Text("Mutual Decision")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .lineLimit(1)
                            .layoutPriority(1)
                            .minimumScaleFactor(0.7)
                        Rectangle()
                            .frame(height: 1)
                        Spacer(minLength: 30)
                    }
                    Text(message.content)
                        .font(.subheadline)
                        .bold()
                }
                .padding(.vertical, 10)
                   
            case .system:
                Spacer(minLength: 24)
                Text(message.content)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                Spacer(minLength: 24)
            }
        }
    }
    

    
}

struct ChatBubble_Previews: PreviewProvider {
    @State static var previewConversation = Conversation(
        id: "1",
        messages: [
            Message(id: "1", role: .user, content: "Hello", createdAt: Date(timeIntervalSinceReferenceDate: 0)),
            Message(id: "2", role: .user, content: "I need help.", createdAt: Date(timeIntervalSinceReferenceDate: 100)),
            Message(id: "3", role: .match, content: "Aw what's the matter?", createdAt: Date(timeIntervalSinceReferenceDate: 200)),
            Message(id: "4", role: .host, content: "I didn't understand that. Please try again.", createdAt: Date(timeIntervalSinceReferenceDate: 300)),
            Message(id: "5", role: .userPrompt, content: "Open the right door", createdAt: Date(timeIntervalSinceReferenceDate: 400)),
            Message(id: "6", role: .system, content: "Open the right door", createdAt: Date(timeIntervalSinceReferenceDate: 400))

        ]
    )

    static var previews: some View {
        VStack{
            ForEach(previewConversation.messages) { message in
                ChatBubble(message: message)
            }
        }
    }
}

