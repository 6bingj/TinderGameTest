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
            
            Text("Hi Micky, \n\nThank you for taking the time to review this prototype! With my skill and passion as a designer/developer, I am confident in my ability to contribute meaningfully to your team as a Design Engineer. \n\nI would greatly appreciate any feedback you might have—both on the prototype itself and my suitability as a candidate.\n\nBest,\nBing\nBingjianliu11@gmail.com")
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color(.systemBackground))
                        .shadow(color: .black.opacity(0.1), radius: 4)
                )
                .padding()
            
            
            hookbookButton
                .padding()
            
            
            
            Spacer()
        }
        .frame(maxWidth: .infinity) // Ensures the VStack fills the full width
        .background(Color(.systemGray6))
        
    }
    
    @ViewBuilder var hookbookButton: some View {
        VStack(alignment:.leading){
            Text("Another demonstration of my skills as a dev:")
                .font(.subheadline)
                .fontWeight(.regular)
            HStack{
                
                Image("HookBookIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .clipShape(
                        RoundedRectangle(cornerRadius: 10)
                    )
                Spacer()
                VStack(alignment:.leading) {
                    Text("HookBook: Sex Health & PrEP")
                        .font(.headline)
                        .minimumScaleFactor(0.6)
                        .fontWeight(.medium)
                    Spacer()
                    
                    Link(destination: URL(string: "https://apps.apple.com/us/app/id1591711557")!, label: {
                        Label("App Store", systemImage: "apple.logo")
                            .foregroundStyle(.white)
                            .padding(.horizontal,20)
                            .padding(.vertical, 3)
                            .background(
                            Capsule()
                            )
                        
                    })
                    
                }
                Spacer()
            }
            .padding(.vertical)
            
            
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4)
        )
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
                                .stroke(Color(.systemBackground), lineWidth: 6)
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
        .onTapGesture {
            guard let url = URL(string: "https://bingjian.page") else {
                return
            }
            
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        
    }
}

#Preview {
    PersonalTabView()
}
