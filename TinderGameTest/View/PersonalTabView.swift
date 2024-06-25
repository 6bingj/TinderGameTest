//
//  PersonalTabView.swift
//  TinderGameTest
//
//  Created by Bingjian Liu on 6/25/24.
//

import SwiftUI

struct PersonalTabView: View {
    var body: some View {
        
        VStack {
            header
            portfolio

        }

    }
    
    @ViewBuilder var portfolio: some View {
        ScrollView {
            Spacer()
            
            Text("Hi Micky, \n\nThank you for taking the time to review this prototype! I remain highly interested in the Design Engineer position on your team. With my skillset as a designer and iOS developer, I am confident in my ability to contribute meaningfully to your team. I would greatly appreciate any feedback you might have—both on the prototype itself and my suitability as a candidate.\n\nBest,\nBing\nBingjianliu11@gmail.com")
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.1), radius: 4)
                )
                .padding()
            
            Button {
                
            } label: {
                Text("HookBook")
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .shadow(color: .black.opacity(0.1), radius: 4)
                    )
                    .padding()
            }

            
            Spacer()
        }
        .frame(maxWidth: .infinity) // Ensures the VStack fills the full width
        .background(Color(.systemGray6))

    }
    
    @ViewBuilder var header: some View {
        VStack {
            HStack {
                Image("TinderLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(.horizontal)
                Spacer()
                
                Image("Shield")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 30)
                    .padding(10)
            }
            
            
            
            picture
            
            HStack {
                Text("Bingjian Liu")
                    .font(.title2)
                    .fontWeight(.regular)
                Image(systemName: "checkmark.seal.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                    .padding(.horizontal,6)
            }
            .padding(20)
            
        }
    }
    
    @ViewBuilder var picture: some View {
        ZStack(alignment:.bottom) {
            Image("Bing")
                .resizable()
                .scaledToFill()
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color("TinderRed"), lineWidth: 6) // Outer red stroke
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 6)
                                .padding(6) // Half of the red stroke's width to center the white stroke inside
                        )
            )
            
            Text("100% GOOD FIT")
                .font(.headline)
                .fontWeight(.bold)
                .foregroundStyle(.white)
                .padding(.horizontal,20)
                .padding(.vertical,7)
                .background(
                Capsule()
                    .fill(Color("TinderRed"))
                )
                .offset(x:0, y:10)
        }
    }
}

#Preview {
    PersonalTabView()
}
