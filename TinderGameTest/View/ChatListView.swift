//
//  ChatListView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/25/24.
//

import SwiftUI

struct ChatListView: View {
    var body: some View {
        
        let realChat =  Chat(name: "Ryan", lastMessage: "Recently active, chat now!", imageName: "profile1", isVerified: true, gameInvite: true)
        
        VStack {
            ZStack {
                HStack {
                    Spacer()
                    
                    Image("Shield")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .padding(10)
                }
                
                Image("TinderLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
            }
            
            List {
                Text("Messages")
                    .font(.headline)
                    .padding(.vertical,5)
                    .padding(.horizontal,3)
                NavigationLink(destination: ChatView()) {
                    ChatRowView(chat: realChat)
                }
                
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ChatListView()
}
