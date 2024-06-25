//
//  ContentView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

struct ContentView: View {
//    let chats = [
//        Chat(name: "Alex", lastMessage: "Hey, how are you?"),
//        Chat(name: "Jamie", lastMessage: "Want to meet up this weekend?"),
//        Chat(name: "Taylor", lastMessage: "I loved your last photo!"),
//        Chat(name: "Jordan", lastMessage: "Let's catch up soon!"),
//        Chat(name: "Morgan", lastMessage: "What's your favorite movie?")
//    ]
    
    var body: some View {
        
        let realChat =  Chat(name: "Ryan", lastMessage: "Recently active, match now!", imageName: "profile1", isVerified: true, isYourTurn: false)

        
        NavigationStack {
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
            .navigationTitle("")
            .toolbar{
                ToolbarItem(placement: .principal) {
                    Image("TinderLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 60)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Image("Shield")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 30)
                        .padding(5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
