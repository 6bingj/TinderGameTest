//
//  ChatToolbarProfile.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import SwiftUI

struct ChatToolbar: View {
    
    @Environment(\.dismiss) private var dismiss

    var chat: Chat = Chat(name: "Ryan", lastMessage: "Recently active, match now!", imageName: "profile1", isVerified: true, gameInvite: true)
    
    var body: some View {
        
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .bold()
            }
            
            Spacer()
            
            VStack {
                Image(chat.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                )
                
                HStack {
                    Text(chat.name)
                        .font(.subheadline)
                    .foregroundStyle(.secondary)
                    if chat.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                            .font(.subheadline)
                    }
                }
            }
            
            Spacer()

        }
    }
}

#Preview {
    ChatToolbar(chat: Chat(name: "Ryan", lastMessage: "Recently active, match now!", imageName: "profile1", isVerified: true, gameInvite: true))
}
