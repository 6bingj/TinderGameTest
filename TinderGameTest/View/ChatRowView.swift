//
//  ChatRowView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/24/24.
//

import SwiftUI


struct ChatRowView: View {
    let chat: Chat

    var body: some View {
        HStack {
            Image(chat.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                )
            VStack(alignment: .leading) {
                HStack {
                    Text(chat.name)
                        .font(.title3)
                        .bold()
                    if chat.isVerified {
                        Image(systemName: "checkmark.seal.fill")
                            .foregroundColor(.blue)
                    }
                    
                    Spacer()
                    
                    if chat.isYourTurn {
                        Text("Your Turn")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(8)
                            .background(
                                Capsule(style: .continuous)
                                    .fill(.black)
                            )
                            .cornerRadius(8)
                    }
                    
                }
                
                Text(chat.lastMessage)
                    .font(.headline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            Spacer()
            
        }
        .padding(.vertical, 8)
    }
}


#Preview {
    ChatRowView(chat: Chat(name: "Pablo", lastMessage: "Recently active, match now!", imageName: "profile1", isVerified: true, isYourTurn: true))
}
