//
//  inputBar.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import SwiftUI

struct InputBar: View {
    @Binding var text: String
    var fillColor: Color = Color(.systemBackground)
    var strokeColor: Color = Color(.systemGray5)
    var placeholder: String = "Type a message"
    
    var tapSendMessage: () -> Void
    
    var body: some View {
        ZStack(alignment: .trailing) {
            TextEditor(text: $text)
                .padding(.vertical, -8)
                .padding(.horizontal, -4)
                .frame(minHeight: 22, maxHeight: 300)
                .foregroundColor(text.isEmpty ? .gray : .primary)
                .padding(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 56)) // Adjust the trailing padding for the Send button
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(fillColor)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(strokeColor, lineWidth: 1)
                        )
                )
                .fixedSize(horizontal: false, vertical: true)
            
            HStack{
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                        .allowsHitTesting(false)
                }
                Spacer()
                Button(action: {
                    withAnimation {
                        tapSendMessage()
                    }
                }) {
                    Text("Send")
                        .foregroundColor(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .blue)
                        .padding(.trailing, 16)
                        .padding(.vertical, 12)
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        
    }
}


#Preview {
    InputBar(text: .constant(""), tapSendMessage: {})
}
