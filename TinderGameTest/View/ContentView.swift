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
                
//                PersonalTabView()
//                    .tabItem {
//                        Image(systemName: "person.fill")
//                    }
                
                Text("Thank you for testing this game! Please contact bingjianliu11@gmail.com if you encounter any issues.")
                    .tabItem {
                        Image(systemName: "person.fill")
                    }
                
            }
            .tint(Color("TinderRed"))
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
