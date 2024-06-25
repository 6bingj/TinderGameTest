//
//  ChatViewBottomSheet.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/25/24.
//

import SwiftUI

struct ChatViewBottomSheet: View {
    
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Break the ice with")
                .font(.subheadline)
//                .fontWeight(.medium)

            Text("AI GAME HOST")
                .fontWeight(.bold)
                .opacity(0.7)
                .tracking(2)
                .padding(.horizontal)
//                .padding(.bottom)
            
            Text("A special storyline generated just for you. Ask any questions to the AI host, and escape together!")
                .fontWeight(.light)
                .font(.subheadline)
//                .padding(.horizontal)
                .padding()
            
            Button {
                viewModel.showBottomSheet.toggle()
                withAnimation{
                    viewModel.gameMode.toggle()
                }
                
            } label: {
                Text("Start a Game with Ryan")
                    .padding()
                    .fontWeight(.heavy)
                    .background(
                    Capsule()
                        .fill(Color("TinderPink"))
                    )
            }
            .tint(.white)
            Spacer()
        }
//        .background()
        .frame(maxHeight: 270)
    }
    
    
    @ViewBuilder func buttonView(title: String, subtitle: String, image: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.heavy)
                .padding()
            Text(subtitle)
                .font(.footnote)
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.clear)
                .background(
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                )
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 20))
        )
        .shadow(color: .black.opacity(0.2), radius: 5 )
        .padding()
    }
    
//    buttonView(title: "Haunted House Escape", subtitle: "A special storyline generated just for you. Ask any questions to the AI host, and escape together!", image: "Gradient3")
}

#Preview {
    ChatViewBottomSheet(viewModel: ChatViewModel())
}
