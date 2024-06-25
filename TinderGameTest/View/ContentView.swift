//
//  ContentView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/23/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationStack {
            TabView {
                ChatListView()
                    .tabItem {
                        Image(systemName: "message.fill")
                    }
                
                PersonalTabView()
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                
            }
            .tint(Color("TinderPink"))
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
